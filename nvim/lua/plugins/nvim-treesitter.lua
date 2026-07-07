return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        local function setup_treesitter_query_compat()
            local query = require("vim.treesitter.query")
            local opts = { force = true, all = false }

            local html_script_type_languages = {
                ["importmap"] = "json",
                ["module"] = "javascript",
                ["application/ecmascript"] = "javascript",
                ["text/ecmascript"] = "javascript",
            }

            local non_filetype_match_injection_language_aliases = {
                ex = "elixir",
                pl = "perl",
                sh = "bash",
                uxn = "uxntal",
                ts = "typescript",
            }

            local function first_node(capture)
                if type(capture) == "table" and capture[1] then
                    return capture[1]
                end
                return capture
            end

            local function get_parser_from_markdown_info_string(injection_alias)
                local match = vim.filetype.match({ filename = "a." .. injection_alias })
                return match or non_filetype_match_injection_language_aliases[injection_alias] or injection_alias
            end

            query.add_predicate("nth?", function(match, _, _, pred)
                local node = first_node(match[pred[2]])
                local n = tonumber(pred[3])
                if node and n and node:parent() and node:parent():named_child_count() > n then
                    return node:parent():named_child(n) == node
                end
                return false
            end, opts)

            query.add_predicate("is?", function(match, _, bufnr, pred)
                local node = first_node(match[pred[2]])
                if not node then
                    return true
                end

                local locals = require("nvim-treesitter.locals")
                local types = { unpack(pred, 3) }
                local _, _, kind = locals.find_definition(node, bufnr)
                return vim.tbl_contains(types, kind)
            end, opts)

            query.add_predicate("kind-eq?", function(match, _, _, pred)
                local node = first_node(match[pred[2]])
                if not node then
                    return true
                end

                local types = { unpack(pred, 3) }
                return vim.tbl_contains(types, node:type())
            end, opts)

            query.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
                local node = first_node(match[pred[2]])
                if not node then
                    return
                end

                local type_attr_value = vim.treesitter.get_node_text(node, bufnr)
                local configured = html_script_type_languages[type_attr_value]
                if configured then
                    metadata["injection.language"] = configured
                else
                    local parts = vim.split(type_attr_value, "/", {})
                    metadata["injection.language"] = parts[#parts]
                end
            end, opts)

            query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
                local node = first_node(match[pred[2]])
                if not node then
                    return
                end

                local injection_alias = vim.treesitter.get_node_text(node, bufnr):lower()
                metadata["injection.language"] = get_parser_from_markdown_info_string(injection_alias)
            end, opts)

            query.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
                local id = pred[2]
                local node = first_node(match[id])
                if not node then
                    return
                end

                if not metadata[id] then
                    metadata[id] = {}
                end
                local text = vim.treesitter.get_node_text(node, bufnr, { metadata = metadata[id] }) or ""
                metadata[id].text = string.lower(text)
            end, opts)
        end

        local configs = require("nvim-treesitter.configs")

        configs.setup({
            ensure_installed = { "terraform", "hcl", "lua", "go", "java", "c", "cpp", "javascript", "typescript", "html", "dart", "css", "gitignore", "gomod", "gosum", "http", "json", "latex", "nginx", "python", "sql", "swift", "yaml", "dockerfile" },
            sync_install = false,
            auto_install = false,
            highlight = { enable = true },
            indent = { enable = true },
        })
        setup_treesitter_query_compat()
    end
}
