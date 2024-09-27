return {
	"epwalsh/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	-- lazy = true,
	-- ft = "markdown",

	dependencies = {
		-- Required.
		"nvim-lua/plenary.nvim",
	},

	opts = {
		ui = { enable = false },
		workspaces = {
			{
				name = "Obsidian",
				path = "~/Obsidian/",
				overrides = {
					notes_subdir = "0. Inbox",
				},
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
		new_notes_location = "notes_subdir",
		-- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
		completion = {
			-- Set to false to disable completion.
			nvim_cmp = true,
			-- Trigger completion at 2 chars.
			min_chars = 2,
			-- prepend_note_id = true,
		},
		note_id_func = function(title)
			return title
		end,
		-- Optional, for templates (see below).
		templates = {
			folder = "Templates",
			date_format = "%d.%m.%Y",
			time_format = "%H:%M",
			-- A map for custom variables, the key should be the variable and the value a function
			substitutions = {},
		},
		mappings = {
			-- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
			["<leader>zl"] = {
				action = function()
					return require("obsidian").util.gf_passthrough()
				end,
				opts = { noremap = false, expr = true, buffer = true },
			},
			-- Toggle check-boxes.
			["<leader>zh"] = {
				action = function()
					return require("obsidian").util.toggle_checkbox()
				end,
				opts = { buffer = true },
			},
		},
	},
}
