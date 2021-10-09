-- Generated using ntangle.nvim
local vnamespace

local function StartSession()
	cos = math.cos
	sin = math.sin
	tan = math.tan
	exp = math.exp
	log = math.log
	acos = math.acos
	asin = math.asin
	atan = math.atan

	vnamespace = vim.api.nvim_create_namespace("quickmath")

	vim.api.nvim_buf_attach(0, false, { on_lines = function(...)
		local content = vim.api.nvim_buf_get_lines(0, 0, -1, true)

		local f, errmsg = loadstring(table.concat(content, "\n"))
		local success
		if not f then
		else
			success, errmsg = pcall(f)
		end

		local def = {}
		for i,line in ipairs(content) do
			if string.find(line, "^%w+%s*=") then
				local name = string.match(line, "^(%w+)%s*=")

				table.insert(def, { lnum = i, name = name })

			end

		end

		vim.api.nvim_buf_clear_namespace(0, vnamespace, 0, -1)

		for _,d in ipairs(def) do
			if _G[d.name] then
				local v = _G[d.name]
				if type(v) == "number" then
					vim.api.nvim_buf_set_virtual_text( 0, vnamespace, d.lnum-1, {{ tostring(v), "Special" }}, {})
				end
				if type(v) == "table" and v.is_complex then
					vim.api.nvim_buf_set_virtual_text( 0, vnamespace, d.lnum-1, {{ tostring(v), "Special" }}, {})
				end

			end
		end

		if errmsg then
			local lcur = vim.api.nvim_call_function("line", { "." }) - 1
			vim.api.nvim_buf_set_virtual_text( 0, vnamespace, lcur, {{ errmsg, "Special" }}, {})
		end

	end})

	vim.api.nvim_command("set ft=lua")

end

return {
StartSession = StartSession,

}

