return {
	"epwalsh/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = true,
	ft = "markdown",

	dependencies = {
		-- Required.
		"nvim-lua/plenary.nvim",
	},

	opts = {
		debug = true,
		workspaces = {
			{
				name = "Obsidian",
				path = "~/Obsidian/Obsidian",
			},
		},
		wiki_link_func = function(opts)
			if opts.id == nil then
				return string.format("[[%s]]", opts.label)
			elseif opts.label ~= opts.id then
				return string.format("[[%s|%s]]", opts.id, opts.label)
			else
				return string.format("[[%s]]", opts.id)
			end
		end,
		new_notes_location = "current_dir",
		-- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
		completion = {
			-- Set to false to disable completion.
			nvim_cmp = true,
			-- Trigger completion at 2 chars.
			min_chars = 2,
			-- prepend_note_id = true,
		},
	},
}