##quickmath
@bind_select_virtual_keymap+=
vim.api.nvim_buf_set_keymap(0, "n", "$", [[:lua require"quickmath".go_eol()<CR>]], { silent=true })

@declare_functions+=
local go_eol

@functions+=
function go_eol()
  @check_if_eol_already
  @if_not_go_eol
  @else_highlight_virtual_text_and_wait
end

@export_symbols+=
go_eol = go_eol,

@if_not_go_eol+=
if not eol then
  vim.api.nvim_win_set_cursor(0, { lnum, line:len() })

@variables+=
local virt_texts = {}

@clear_virtual_text_store
virt_texts = {}

@save_virt_text_pos+=
virt_texts[d.lnum] = tostring(v)

@check_if_eol_already+=
local line = vim.api.nvim_get_current_line()
local lnum, lcol = unpack(vim.api.nvim_win_get_cursor(0))
local cur = vim.str_utfindex(line, lcol)
local last = vim.str_utfindex(line)
local eol = cur == last-1

@else_highlight_virtual_text_and_wait+=
else 
  if virt_texts[lnum] then
    @clear_virtual_text
    for vlnum, vtxt in pairs(virt_texts) do

      local hlgroup = "Special"
      if vlnum == lnum then
        hlgroup = "Visual"
      end
      vim.api.nvim_buf_set_virtual_text( 0, vnamespace, vlnum-1, {{ virt_texts[vlnum], hlgroup }}, {})
    end

    vim.schedule(function()
      local key = vim.fn.getchar()
      @if_y_yank_text
      @clear_virtual_text
      @restore_virtual_text
    end)
  end
end

@restore_virtual_text+=
for vlnum, vtxt in pairs(virt_texts) do
  local hlgroup = "Special"
  vim.api.nvim_buf_set_virtual_text( 0, vnamespace, vlnum-1, {{ virt_texts[vlnum], hlgroup }}, {})
end

@if_y_yank_text+=
local c = string.char(key)
if c == 'y' then
  vim.api.nvim_command(([[let @+="%s"]]):format(tostring(virt_texts[lnum])))
end
