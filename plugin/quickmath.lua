-- to have a clean 100% lua statistics in Github ;) I know it's perfectionism
vim.cmd [[command! Quickmath lua require("quickmath").StartSession()]]
vim.cmd [[command! QMSelectOutput lua require("quickmath").go_eol()]]
