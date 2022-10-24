-- Generated using ntangle.nvim
local vnamespace

local virt_texts = {}

virt_texts = {}

local vector = {}
vector.__index = vector

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

	vec = vec

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

				if isvec(v) then
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

function vec(...)
  -- Create a new vector
  -- with a given set of values
  -- and a dim of the number of values
  local v = {}
  local dim = 0
  if type(...) == "table" then
    v = ...
    dim = #v
  else
    v = {...}
    dim = select("#", ...)
  end
  v.dim = dim
  setmetatable(v, vector)
  return v
end

function isvec(v)
  return getmetatable(v) == vector
end

local function vecmatch(v1, v2)
  return isvec(v1) and isvec(v2) and v1.dim == v2.dim
end

function vector:clone()
  -- Return a copy of the vector
  local v = {}
  for i = 1, self.dim do
    v[i] = self[i]
  end
  v.dim = self.dim
  setmetatable(v, vector)
  return v
end

function vector:unpack()
  -- Return the values of the vector
  -- as a list of values
  return unpack(self, 1, self.dim)
end

function vector:mag()
  -- Return the magnitude of the vector
  local mag = 0
  for i = 1, self.dim do
    mag = mag + self[i] * self[i]
  end
  return math.sqrt(mag)
end

function vector:magsq()
  -- Return the magnitude squared of the vector
  local mag = 0
  for i = 1, self.dim do
    mag = mag + self[i] * self[i]
  end
  return mag
end

function vector:setmag(mag)
  -- Set the magnitude of the vector
  local magsq = self:magsq()
  if magsq == 0 then
    return self:clone()
  end
  local scale = mag / math.sqrt(magsq)
  return self:scale(scale)
end

function vector:scale(s)
  -- Scale a vector by a scalar value
  -- or another vector (element-wise)
  local v = self:clone()
  if isvec(s) then
    if not vecmatch(self, s) then
      error("Cannot scale vectors of different dimensions")
    end
    for i = 1, self.dim do
      v[i] = v[i] * s[i]
    end
  else
    for i = 1, self.dim do
      v[i] = v[i] * s
    end
  end
  return v
end

function vector:norm()
  -- Normalize the vector
  local mag = self:mag()
  local v = self:clone()
  if mag == 0 then
    return v
  end
  for i = 1, self.dim do
    v[i] = v[i] / mag
  end
  return v
end

function vector:dist(v)
  -- Return the distance between two vectors
  if not vecmatch(self, v) then
    error("Cannot calculate distance between vectors of different dimensions")
  end
  local dist = 0
  for i = 1, self.dim do
    dist = dist + (self[i] - v[i]) * (self[i] - v[i])
  end
  return math.sqrt(dist)
end

function vector:distsq(v)
  -- Return the distance squared between two vectors
  if not vecmatch(self, v) then
    error("Cannot calculate distance between vectors of different dimensions")
  end
  local dist = 0
  for i = 1, self.dim do
    dist = dist + (self[i] - v[i]) * (self[i] - v[i])
  end
  return dist
end

function vector:limit(max)
  -- Limit the magnitude of the vector
  local magsq = self:magsq()
  if magsq > max * max then
    return self:clone():setmag(max)
  end
  return self:clone()
end

function vector:__unm()
  -- Return the negative of the vector
  local v = self:clone()
  for i = 1, self.dim do
    v[i] = -self[i]
  end
  return v
end

function vector:__add(v)
  -- Add two vectors
  if not vecmatch(self, v) then
    error("Cannot add vectors of different dimensions")
  end
  local v3 = self:clone()
  for i = 1, self.dim do
    v3[i] = v3[i] + v[i]
  end
  return v3
end

function vector:__sub(v)
  -- Subtract two vectors
  if not vecmatch(self, v) then
    error("Cannot subtract vectors of different dimensions")
  end
  local v3 = self:clone()
  for i = 1, self.dim do
    v3[i] = v3[i] - v[i]
  end
  return v3
end

function vector:__mul(v)
  -- Calculate the dot product of two vectors
  -- or multiply a vector by a scalar
  if isvec(v) then
    if not vecmatch(self, v) then
      error("Cannot multiply vectors of different dimensions")
    end
    local v3 = 0
    for i = 1, self.dim do
      v3 = v3 + self[i] * v[i]
    end
    return v3
  else
    return self:scale(v)
  end
end

function vector:__tostring()
  -- Return a string representation of the vector
  local s = "("
  for i = 1, self.dim do
    s = s .. tostring(self[i])
    if i ~= self.dim then
      s = s .. ", "
    end
  end
  s = s .. ")"
  return s
end

return {
StartSession = StartSession,

go_eol = go_eol,

}

