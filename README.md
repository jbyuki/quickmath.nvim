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

## Vectors

In addition to the math module there is a custom vector implementation.
The only global function is `vec(...)` which takes the vectors components.
The vector it self implements a lot of functions and some operators the work on them.
Vectors are immutable so all functions and operations that returns a vector,
returns a new vector.

The vectors can be of any dimension but naturally doing operations on to vectors
requires them to be of the same dimensionality.

You can create a vector in one of three ways:
```lua
a = vec(1,2,3)
b = vec({4,5,6})
c = vec {7,8,9}
```

<details>
<summary><h3>Functions</h3></summary>

#### `clone`

Creates a clone of the vector.

```lua
a = vec(1,2,3)
b = a:clone() -- b == vec(1,2,3)
```

#### `unpack`

Unpacks the vector into its components.

```lua
a = vec(1,2,3)
x, y, z = a:unpack() -- x = 1, y = 2, z = 3
```

#### `mag`

Get the magnitude, or length, of the vector.

```lua
a = vec(3,4)
len = a:mag() -- len = 5
```

#### `magsq`

Get the square magnitude, or length, of the vector.
This has better performance if you don't need the actual
magnitude but are for example comparing one vector to another.

```lua
a = vec(3,4)
len = a:magsq() -- len = 25
```

#### `setmag`

Creates a copy of the vector with the same direction but the
given magnitude.

```lua
a = vec(3,4)
b = a:setmag(10) -- b == vec(6, 8)
```

#### `scale`

Takes a number or a vector as input and created a new vector
and scales it either by the given factor or element-wise by vector.

```lua
a = vec(3,4)
b = a:scale(2) -- b == vec(6, 8)
-- or
a = vec(3,4)
b = a:scale(vec(1,2)) -- b == vec(3, 8)
```

#### `norm`

Creates a normalized copy of the vector.

```lua
a = vec(3,4)
b = a:norm() -- b = vec(0.6, 0.8)
len = b:mag() -- len == 1
```

#### `dist`

Calculates the distance between the vectors.

```lua
a = vec(1,0)
b = vec(-1,0)
c = a:dist(b) -- c == 2
```

#### `distsq`

Calculates the square distance between the vectors.
Like `magsq` this is more performant and great if you are
comparing vectors.

```lua
a = vec(1,0)
b = vec(-1,0)
c = a:distsq(b) -- c == 4
```

#### `limit`

Creates a copy of the vector and limits its magnitude
to the given value.

```lua
a = vec(6,8)
b = a:limit(5) -- b = vec(3,4)
-- and
a = vec(6,8)
b = a:limit(25) -- b = vec(6,8)
```

</details>

<details>
<summary><h3>Operator implementations</h3></summary>

#### Negating

Vectors can be negated simply by pretending a `-`.

```lua
a = vec(1,2)
b = -a -- b == vec(-1,-2)
```

#### Adding

```lua
a = vec(1,2)
b = vec(2,1)
c = a + b -- c == vec(3,3)
```

#### Subtracting

```lua
a = vec(1,2)
b = vec(2,1)
c = a - b -- c == vec(-1,1)
```

#### Dot product

```lua
a = vec(1,2)
b = vec(2,1)
c = a * b -- c == 4
```

#### Multiply

```lua
a = vec(1,2)
c = a * 5 -- c == vec(5,10)
```

</details>

Note
----

The local plugin that I use has actually more functionnalities that I added progressively when I needed them such as complex numbers, plots, bode plots, etc... They weren't added in this version because they need external installation but if there are request I can consider adding them with proper support.
