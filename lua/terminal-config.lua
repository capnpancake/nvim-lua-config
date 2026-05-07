local job_id = 0
vim.keymap.set('n', '<leader>st', function ()
	vim.cmd.vnew()
	vim.cmd.term()
	vim.cmd.wincmd('J')
	vim.api.nvim_win_set_height(0, 5)

	job_id = vim.bo.channel
end)

vim.keymap.set('n', '<leader>list', function()
	vim.fn.chansend(job_id, { "ls -al\r\n" })
end)

vim.keymap.set('n', '<leader>gadd', function()
	vim.fn.chansend(job_id, { "git add .\r\n" })
end)

vim.keymap.set('n', '<leader>gst', function()
	vim.fn.chansend(job_id, { "git status\r\n" })
end)
