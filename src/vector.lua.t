##quickmath
@variables+=
local vector = {}
vector.__index = vector

@functions+=
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

@functions+=
function isvec(v)
  return getmetatable(v) == vector
end

@functions+=
local function vecmatch(v1, v2)
  return isvec(v1) and isvec(v2) and v1.dim == v2.dim
end

@functions+=
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

@functions+=
function vector:unpack()
  -- Return the values of the vector
  -- as a list of values
  return unpack(self, 1, self.dim)
end

@functions+=
function vector:mag()
  -- Return the magnitude of the vector
  local mag = 0
  for i = 1, self.dim do
    mag = mag + self[i] * self[i]
  end
  return math.sqrt(mag)
end

@functions+=
function vector:magsq()
  -- Return the magnitude squared of the vector
  local mag = 0
  for i = 1, self.dim do
    mag = mag + self[i] * self[i]
  end
  return mag
end

@functions+=
function vector:setmag(mag)
  -- Set the magnitude of the vector
  local magsq = self:magsq()
  if magsq == 0 then
    return self:clone()
  end
  local scale = mag / math.sqrt(magsq)
  return self:scale(scale)
end

@functions+=
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

@functions+=
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

@functions+=
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

@functions+=
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

@functions+=
function vector:limit(max)
  -- Limit the magnitude of the vector
  local magsq = self:magsq()
  if magsq > max * max then
    return self:clone():setmag(max)
  end
  return self:clone()
end

@functions+=
function vector:__unm()
  -- Return the negative of the vector
  local v = self:clone()
  for i = 1, self.dim do
    v[i] = -self[i]
  end
  return v
end

@functions+=
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

@functions+=
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

@functions+=
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

@functions+=
function vector:__tostring()
  -- Return a string representation of the vector
  local s = "("
  for i = 1, self.dim do
    s = s .. self[i]
    if i ~= self.dim then
      s = s .. ", "
    end
  end
  s = s .. ")"
  return s
end

@if_vector_put_virtual_text+=
if isvec(v) then
  vim.api.nvim_buf_set_virtual_text( 0, vnamespace, d.lnum-1, {{ tostring(v), "Special" }}, {})
  @save_virt_text_pos
end

@global_functions+=
vec = vec
