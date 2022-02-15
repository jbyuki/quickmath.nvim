-- Generated using ntangle.nvim
local vnamespace

local virt_texts = {}

virt_texts = {}

local go_eol

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
		      virt_texts[d.lnum] = tostring(v)

				end
				if type(v) == "table" and v.is_complex then
					vim.api.nvim_buf_set_virtual_text( 0, vnamespace, d.lnum-1, {{ tostring(v), "Special" }}, {})
				  virt_texts[d.lnum] = tostring(v)

				end

			end
		end

		if errmsg then
			local lcur = vim.api.nvim_call_function("line", { "." }) - 1
			vim.api.nvim_buf_set_virtual_text( 0, vnamespace, lcur, {{ errmsg, "Special" }}, {})
		end

	end})

	vim.api.nvim_command("set ft=lua")

  vim.cmd [[set buftype=nowrite]]
  vim.api.nvim_buf_set_keymap(0, "n", "$", [[:lua require"quickmath".go_eol()<CR>]], { silent=true })

end

function go_eol()
  local line = vim.api.nvim_get_current_line()
  local lnum, lcol = unpack(vim.api.nvim_win_get_cursor(0))
  local cur = vim.str_utfindex(line, lcol)
  local last = vim.str_utfindex(line)
  local eol = cur == last-1

  if not eol then
    vim.api.nvim_win_set_cursor(0, { lnum, line:len() })

  else 
    if virt_texts[lnum] then
      vim.api.nvim_buf_clear_namespace(0, vnamespace, 0, -1)

      for vlnum, vtxt in pairs(virt_texts) do

        local hlgroup = "Special"
        if vlnum == lnum then
          hlgroup = "Visual"
        end
        vim.api.nvim_buf_set_virtual_text( 0, vnamespace, vlnum-1, {{ virt_texts[vlnum], hlgroup }}, {})
      end

      vim.schedule(function()
        local key = vim.fn.getchar()
        local c = string.char(key)
        if c == 'y' then
          vim.api.nvim_command(([[let @+="%s"]]):format(tostring(virt_texts[lnum])))
        end
        vim.api.nvim_buf_clear_namespace(0, vnamespace, 0, -1)

        for vlnum, vtxt in pairs(virt_texts) do
          local hlgroup = "Special"
          vim.api.nvim_buf_set_virtual_text( 0, vnamespace, vlnum-1, {{ virt_texts[vlnum], hlgroup }}, {})
        end

      end)
    end
  end

end

return {
StartSession = StartSession,

go_eol = go_eol,

}

