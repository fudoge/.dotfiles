return {
    'chipsenkbeil/distant.nvim',
    branch = 'v0.3',
    cmd = {
        "Distant",
        "DistantConnect",
        "DistantLaunch",
        "DistantOpen",
        "DistantShell",
    },
    config = function()
        require('distant'):setup()
    end
}
