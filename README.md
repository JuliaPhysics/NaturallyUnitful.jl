[![CI](https://github.com/JuliaPhysics/NaturallyUnitful.jl/actions/workflows/ci.yml/badge.svg)](https://github.com/JuliaPhysics/NaturallyUnitful.jl/actions/workflows/ci.yml)
[![Coverage Status](https://coveralls.io/repos/github/JuliaPhysics/NaturallyUnitful.jl/badge.svg)](https://coveralls.io/github/JuliaPhysics/NaturallyUnitful.jl)
[![codecov.io](https://codecov.io/github/JuliaPhysics/NaturallyUnitful.jl/coverage.svg)](https://codecov.io/github/JuliaPhysics/NaturallyUnitful.jl)

# NaturallyUnitful.jl
A Julia package implementing flexible conversions via natural units for [Unitful.jl](https://github.com/JuliaPhysics/Unitful.jl). Reexports Unitful.

- Define custom natural unit systems:
    - Take any quantities to be 1.
    - Retain arbitrary combinations of units.
- Dynamically derives appropriate unit combinations.
- Evaluate mass-dimension (or equivalent) for any quantity or unit.

Includes two standard unit systems:
- `PARTICLE_UNITS` sets `c = ħ = k = 4πϵ₀ = 1`, `mol = NA`. It is the default for all functions.
- `QG_UNITS` includes all that plus `G = 1`. It has the alias `unitless`. 

## Interface
Convert units via `natural`, with the option to use a custom combination of units
```julia
    julia> using NaturallyUnitful

    julia> natural(10u"N")
    1.2316181391726781e13 eV^2

    julia> natural(10u"N", u"kg")
    3.913938995812104e-59 kg^2
```
For quantities that are unitless in a given system, the exact unit specified will be used (if compatible).
```julia
    julia> natural(10u"N", unitless) # In QG_UNITS, all quantities are unitless
    8.262717639698035e-44

    julia> natural(10u"N", unitless, u"s^-1")
    1.5326173119543876 s^-1
```
To explicitly check that dimensionless quantities are returned as regular floats, specify `NoUnits`, for
example
```julia
julia> natural(1u"km/s", NoUnits)
3.3356409519815205e-6

julia> natural(1u"kg", NoUnits)
ERROR: DimensionError:  and kg c^2 are not dimensionally compatible.
```
The unit that will be used by `natural` can be found using `naturalunit`.
```julia
    julia> naturalunit(10u"N")
    eV^2

    julia> naturalunit(10u"N", u"kg")
    kg^2

    julia> naturalunit(10u"N", unitless)
    

    julia> naturalunit(10u"N", unitless, u"s^-1")
    s^-1
```
Get the natural dimension(s) using `natdims`/`natdim` - this is the powers of the standard units needed to express the quantity. In particle units this is the 'mass-dimension'.
```julia
    julia> natdim(10u"N") # Naturally eV^2
    2//1

    julia> natdims(10u"N", unitless) # There are 0 units left in this system
    0-element StaticArraysCore.SVector{0, Rational{Int64}} with indices SOneTo(0)
```
### Custom Systems
Define a new natural unit system via `NaturalSystem`. Imagine you want to set `10N = 1`, for some reason...
```julia
    julia> weirdsys = NaturalSystem((u"m", u"s"), (10u"N",));

    julia> natural(u"kg", weirdsys)
    0.1 s^2 m^-1

    julia> natdims(u"kg", weirdsys)
    2-element StaticArraysCore.SVector{2, Rational{Int64}} with indices SOneTo(2):
     -1
      2
```
Any `NaturalSystem` can be called as a function like `natural`.
```julia
    julia> weirdsys(u"kg")
    0.1 s^2 m^-1

    julia> unitless(u"kg")
    4.5946711112415865e7
```
