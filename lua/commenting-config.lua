require('Comment').setup({
	pre_hook = function(ctx)
		if vim.bo.filetype ~= "svelte" then return nil end

		local node = vim.treesitter.get_node():parent()
		if not node then return nil end

		while node do
			local t = node:type()
			if t == "script_element" then
				return '// %s'
			elseif t == "style_element" then
				return '/* %s */'
			end
			node = node:parent()
		end
		return '<!-- %s -->'
	end
})
