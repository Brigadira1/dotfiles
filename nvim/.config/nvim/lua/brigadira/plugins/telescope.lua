return {
	"nvim-telescope/telescope.nvim",
	-- The reference to the master branch was added in order to get rid of some of the deprecation warnings when using the stable branch
	branch = "master",
	-- branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local transform_mod = require("telescope.actions.mt").transform_mod

		local trouble = require("trouble")
		local trouble_telescope = require("trouble.sources.telescope")

		-- or create your custom action
		local custom_actions = transform_mod({
			open_trouble_qflist = function(prompt_bufnr)
				trouble.toggle("quickfix")
			end,
		})

		telescope.setup({
			defaults = {
				path_display = { "smart" },
				file_ignore_patterns = {
					"%.git/",
					"%.venv/",
					"%.venv/.*",
					"venv/",
					"venv/.*",
					"__pycache__/",
				},
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-q>"] = actions.send_selected_to_qflist + custom_actions.open_trouble_qflist,
						["<C-t>"] = trouble_telescope.open,
					},
				},
			},
			pickers = {
				live_grep = {
					additional_args = function(_)
						return { "--hidden", "--no-ignore-vcs" }
					end,
					hidden = true,
					no_ignore = true,
				},
				find_files = {
					additional_args = function(_)
						return { "--hidden", "--no-ignore-vcs" }
					end,
					no_ignore = true,
					hidden = true,
				},
			},
		})

		telescope.load_extension("fzf")
	end,
}
