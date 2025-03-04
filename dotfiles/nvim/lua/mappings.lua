-- Oil
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- clear search highlighting
vim.keymap.set("n", "<leader>n", ":nohlsearch<CR>", { desc = "Clear search highlight" })

-- dismiss notifications
vim.keymap.set("n", "<leader>d", ":NoiceDismiss<CR>", { desc = "Dismiss Notifications" })

-- fuzzy find file
-- vim.keymap.set("n", "<leader>ff", ":FZF<CR>", { desc = "Fuzzy Find" })

-- telescope
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find File" })
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Live Grep" })

-- latex shortcuts
vim.api.nvim_create_autocmd("FileType", {
	pattern = "tex", -- Filetype for LaTeX files
	callback = function()
		vim.keymap.set("n", "<leader>mr", ":VimtexCompile<CR>", { desc = "Compile LaTeX", buffer = true })
	end,
})

-- Rust shortcuts
vim.api.nvim_create_autocmd("FileType", {
	pattern = "rust", -- Filetype for Rust files
	callback = function()
		-- Function to run a command in a new Alacritty window within the current working directory
		local function run_in_alacritty(cmd)
			-- Get the current working directory of the buffer
			local cwd = vim.fn.expand("%:p:h")
			-- Construct the spawn command with the correct working directory
			local spawn_cmd = string.format("riverctl spawn 'alacritty --working-directory %s --hold -e %s'", cwd, cmd)
			vim.fn.system(spawn_cmd) -- Execute the command using Neovim's system function
		end

		-- Compile and Run Rust code with <leader>mr
		vim.keymap.set("n", "<leader>mr", function()
			run_in_alacritty("cargo run")
		end, { desc = "Compile and Run Rust code in a new Alacritty window", buffer = true })

		-- Compile Rust code with <leader>mc
		vim.keymap.set("n", "<leader>mc", function()
			run_in_alacritty("cargo build")
		end, { desc = "Compile Rust code in a new Alacritty window", buffer = true })
	end,
})

-- Go shortcuts
vim.api.nvim_create_autocmd("FileType", {
	pattern = "go", -- Filetype for Go files
	callback = function()
		-- Function to run a command in a new Alacritty window within the current working directory
		local function run_in_alacritty(cmd)
			-- Get the current working directory of the buffer
			local cwd = vim.fn.expand("%:p:h")
			-- Construct the spawn command with the correct working directory
			local spawn_cmd = string.format("riverctl spawn 'alacritty --working-directory %s --hold -e %s'", cwd, cmd)
			vim.fn.system(spawn_cmd) -- Execute the command using Neovim's system function
		end

		-- Run Go program with <leader>mr
		vim.keymap.set("n", "<leader>mr", function()
			run_in_alacritty("go run .")
		end, { desc = "Run Go program in a new Alacritty window", buffer = true })

		-- Build Go program with <leader>mc
		vim.keymap.set("n", "<leader>mc", function()
			run_in_alacritty("go build")
		end, { desc = "Build Go program in a new Alacritty window", buffer = true })

		-- Test Go program with <leader>mt
		vim.keymap.set("n", "<leader>mt", function()
			run_in_alacritty("go test ./...")
		end, { desc = "Run Go tests in a new Alacritty window", buffer = true })
	end,
})

-- C shortcuts
vim.api.nvim_create_autocmd("FileType", {
	pattern = "c", -- Filetype for C files
	callback = function()
		-- Function to run a command in a new Alacritty window within the current working directory
		local function run_in_alacritty(cmd)
			-- Get the current working directory of the buffer
			local cwd = vim.fn.expand("%:p:h")
			-- Construct the spawn command with the correct working directory
			local spawn_cmd = string.format("riverctl spawn 'alacritty --working-directory %s --hold -e %s'", cwd, cmd)
			vim.fn.system(spawn_cmd) -- Execute the command using Neovim's system function
		end

		-- Compile and Run C code with <leader>mr
		vim.keymap.set("n", "<leader>mr", function()
			run_in_alacritty("tcc -run " .. vim.fn.expand("%"))
		end, { desc = "Compile and Run C code in a new Alacritty window", buffer = true })
	end,
})

-- Zig shortcuts
vim.api.nvim_create_autocmd("FileType", {
	pattern = "zig", -- Filetype for C files
	callback = function()
		-- Function to run a command in a new Alacritty window within the current working directory
		local function run_in_alacritty(cmd)
			-- Get the current working directory of the buffer
			local cwd = vim.fn.expand("%:p:h")
			-- Construct the spawn command with the correct working directory
			local spawn_cmd = string.format("riverctl spawn 'alacritty --working-directory %s --hold -e %s'", cwd, cmd)
			vim.fn.system(spawn_cmd) -- Execute the command using Neovim's system function
		end

		vim.keymap.set("n", "<leader>mr", function()
			run_in_alacritty("zig build run")
		end, { desc = "Compile and Run Zig code in a new Alacritty window", buffer = true })
	end,
})
