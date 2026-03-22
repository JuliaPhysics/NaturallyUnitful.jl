# NaturallyUnitful.jl
A Julia package implementing flexible conversions via natural units for [Unitful.jl](https://github.com/JuliaPhysics/Unitful.jl).

- Define custom natural unit systems:
    - Take any quantities to be 1
    - Retain arbitrary combinations of units
- Dynamically derives appropriate unit combinations
- Evaluate mass-dimension (or equivalent) for any quantity or unit.

Uses particle physics units (`c = ħ = k = 4πϵ₀ = 1`) by default, which are extended to include `G = 1` in `QG_UNITS` (available via `unitless`).

```julia
    julia> using NaturallyUnitful, Unitful

    julia> natdim(10u"N")
    2//1
    julia> natural(10u"N")
    1.2316181391726781e13 eV^2
    julia> unitless(10u"N")
    8.262717639698035e-44
```

Imagine you want to set `10N = 1`, for some reason...
```julia
    julia> weirdsys = NaturalSystem((u"m", u"s"), (10u"N",));

    julia> weirdsys(u"kg")
    0.1 s^2 m^-1
```

## Main Interface
- Convert units via `natural`, or into a number via `unitless`
- Define a new natural unit system via `NaturalSystem`
    - `NaturalSystem`s can be called as functions like `natural` for convenience
- Get natural dimensions using `natdims`/`natdim`