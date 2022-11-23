##quickmath
@add_variable_assignement_to_anon+=
for i, line in ipairs(content) do
	local line = content[i]
	if not string.find(line, "^%w+%s*=") and not string.find(line, "^%s*$") then
		@append_anon_variable_def
	end
	content[i] = line
end

@add_variable_assignement_to_anon-=
local anon_n = 1

@append_anon_variable_def+=
line = ("anon%d = %s"):format(anon_n, line)
anon_n = anon_n + 1
