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

This is a long standing plug-in in my collections of not really polished plugins, not that my released my plugins are very polished either. I felt obligated to release it because of useful it is, especially if you study or work in a scientific field, and because there are no really equivalent plug-ins now in the nvim plugin ecosystem. It can pointed out also that in outside nvim really, we usually do our computations the traditional way, on a calculator or more "programming mindset" persons do it in a python interpreter or in matlab maybe but these tools don't offer a live computation environnement, i.e. an environnement where values of variables can be changed on the fly, and all subsequent calculations are updated immediately, which is terribly useful in any involved computation! The only tool that I'm aware which is obviously used is Excel but still, it feels heavy and clunky.

Using an environnement such as nvim allows to implement use it as a live calculator very easily and it is terribly useful and should be more widely known. Btw, the source of this plugin is only ~70 lines long so it's very easy to implement it.

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

Note
----

The local plugin that I use has actually more functionnalities that I added progressively when I needed them such as complex numbers, plots, bode plots, etc... They weren't added in this version because they need external installation but if there are request I can consider adding them with proper support.
