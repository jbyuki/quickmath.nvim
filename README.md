Quickmath
=========

A simple plugin to do live calculations in Neovim.

![quickmath screenshot](https://raw.githubusercontent.com/jbyuki/gifs/main/quickmath.PNG)

Install
-------

Install using your prefered method:
- [vim-plug](https://github.com/junegunn/vim-plug).
```vim
Plug 'jbyuki/quickmath.nvim'
```

- [packer.nvim](https://github.com/wbthomason/packer.nvim)
```lua
use "jbyuki/quickmath.nvim"
```

Background
----------

This is a long standing plug-in in my collections of not really polished plugins, not that my released my plugins are very polished either. I felt obligated to release it because of how useful it is, especially if you study or work in a scientific field, and because there are no really equivalent plug-ins now in the nvim plugin ecosystem. It can pointed out also that outside the realm of nvim really, we usually do our computations in the traditional way, on a calculator or a more "programming mindset" person could do it in a python interpreter or in matlab repl maybe but these tools don't offer a live computation environnement, i.e. an environnement where values of variables can be changed on the fly, and all subsequent calculations are updated immediately, which is terribly useful in any involved computation! The only tool that I see other persons use that I'm aware is Excel but still, it feels very heavy and clunky.

Using an environnement such as nvim allows to implement and use a live calculator very easily and it is terribly useful and should be more widely known. Btw, the source of this plugin is only ~70 lines long so it's very easy to implement it.

Usage
-----

Ok, enough rants.

You can use this tool simply by invoking:

```lua
:Quickmath
```

All calculations is actually lua code.
This means you can use functions which are available in the `math` module.
Lists them using `:lua print(vim.inspect(math))`. 
All the math module functions are put in global namespace when quickmath is initiated. So instead of writing `math.cos`, `cos` can be simply written.

**Get that output**

You can select the output by pressing `$` when at the end of the line, or `$$` anywhere else in the line.
Then just `y`ank.


Note
----

The local plugin that I use has actually more functionnalities that I added progressively when I needed them such as complex numbers, plots, bode plots, etc... They weren't added in this version because they need external installation but if there are request I can consider adding them with proper support.
