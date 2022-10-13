##quickmath
@../lua/quickmath/init.lua=
@variables
@matrix_module
@declare_functions
@start_session
@functions
return {
@export_symbols
}

@start_session+=
local function StartSession()
	@global_functions

	@create_virtual_text_namespace
	@attach_callback_to_buffer
	@setup_buffer_to_lua_filetype
  @setup_buffer_as_no_need_to_save
  @bind_select_virtual_keymap
end

@export_symbols+=
StartSession = StartSession,

@attach_callback_to_buffer+=
vim.api.nvim_buf_attach(0, false, { on_lines = function(...)
	@init_graph_data
	@get_buffer_content
	@execute_lua_script
	@parse_variables_definitions
	@clear_virtual_text
  @clear_virtual_text_store
	@put_virtual_text_with_values
	@put_error_msg_at_current_line_if_error
end})

@get_buffer_content+=
local content = vim.api.nvim_buf_get_lines(0, 0, -1, true)

@execute_lua_script+=
local f, errmsg = loadstring(table.concat(content, "\n"))
local success
if not f then
else
	success, errmsg = pcall(f)
end

@parse_variables_definitions+=
local def = {}
for i,line in ipairs(content) do
	@check_if_line_is_definition
end

@check_if_line_is_definition+=
if string.find(line, "^%w+%s*=") then
	@get_variable_name
	@add_to_definition_list
end

@get_variable_name+=
local name = string.match(line, "^(%w+)%s*=")

@add_to_definition_list+=
table.insert(def, { lnum = i, name = name })

@variables+=
local vnamespace

@create_virtual_text_namespace+=
vnamespace = vim.api.nvim_create_namespace("quickmath")

@clear_virtual_text+=
vim.api.nvim_buf_clear_namespace(0, vnamespace, 0, -1)

@put_virtual_text_with_values+=
for _,d in ipairs(def) do
	if _G[d.name] then
		local v = _G[d.name]
		if type(v) == "number" then
			vim.api.nvim_buf_set_virtual_text( 0, vnamespace, d.lnum-1, {{ tostring(v), "Special" }}, {})
      @save_virt_text_pos
		end
		@if_complex_number_put_virtual_text
		@if_matrix_put_virtual_text
		@if_vector_put_virtual_text
	end
end

@setup_buffer_to_lua_filetype+=
vim.api.nvim_command("set ft=lua")

@put_error_msg_at_current_line_if_error+=
if errmsg then
	local lcur = vim.api.nvim_call_function("line", { "." }) - 1
	vim.api.nvim_buf_set_virtual_text( 0, vnamespace, lcur, {{ errmsg, "Special" }}, {})
end

@if_complex_number_put_virtual_text+=
if type(v) == "table" and v.is_complex then
	vim.api.nvim_buf_set_virtual_text( 0, vnamespace, d.lnum-1, {{ tostring(v), "Special" }}, {})
  @save_virt_text_pos
end

@global_functions+=
cos = math.cos
sin = math.sin
tan = math.tan
exp = math.exp
log = math.log
acos = math.acos
asin = math.asin
atan = math.atan

@setup_buffer_as_no_need_to_save+=
vim.cmd [[set buftype=nowrite]]
