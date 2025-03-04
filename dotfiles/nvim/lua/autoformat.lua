---- autoformat lua
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.lua",
	callback = function()
		require("stylua").format()
	end,
})

---- the big one
---- autoformat go, c
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.go", "*.c", "*.cpp", "*.h", "*.hpp" },
	callback = function()
		vim.lsp.buf.format()
	end,
})

---- autoformat latex
-- vim.api.nvim_create_autocmd("BufWritePre", {
-- 	pattern = "*.tex", -- Matches all LaTeX files
-- 	callback = function()
-- 		vim.lsp.buf.format({ async = false }) -- Format synchronously before saving
-- 	end,
-- })

---- autoformat go
---- vim.api.nvim_create_autocmd("BufWritePre", {
---- 	pattern = "*.go",
---- 	callback = function()
---- 		local bufnr = vim.api.nvim_get_current_buf()
---- 		local filename = vim.api.nvim_buf_get_name(bufnr)
---- 		vim.fn.system({ "go", "fmt", filename })
---- 		vim.cmd("e") -- Reload the file
---- 	end,
---- })
