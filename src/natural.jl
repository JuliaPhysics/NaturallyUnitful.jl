"""
    natdims(q, system::NaturalSystem = DEFAULT_UNITS)

Get the dimensions of `q` in terms of the preferred units of `system`, as a vector of powers.
"""
natdims(q, system::NaturalSystem = DEFAULT_UNITS) = weights(system)(q)

"""
    natdim(q, system::NaturalSystem = DEFAULT_UNITS)

For one-unit `system`, get the power of the standard unit needed to express `q`.
"""
natdim(args...) = only(natdims(args...))

"""
    naturalunit(q, system::NaturalSystem = DEFAULT_UNITS[, units::Units...])

Find the correct unit for `q` using combinations of the given `units`, with natural conversions from `system`.
If no `units` are specified, uses the default units for `system`. 
"""
function naturalunit(q, system::NaturalSystem, units::Units...)
    qdims = natdims(q, system)

    if iszero(qdims)
        unit = only(units) # No point trying to infer from multiple units
        
        if !iszero(natdims(unit, system))
            throw(NaturalDimensionError(q, units, system))
        end

        return unit
    end

    unit_powers = try
        exact_ldiv(natdims(units, system), qdims)
    catch err
        if err isa LinearAlgebra.SingularException
            throw(NaturalDimensionError(q, units, system))
        else
            rethrow(err)
        end
    end

    unit = mapreduce(^, *, units, unit_powers, init = NoUnits)

    if isinfdims(unit)
        throw(NaturalDimensionError(q, units, system))
    end

    unit
end

naturalunit(q, system::NaturalSystem) = system.units(q)
naturalunit(q, units::Units...) = naturalunit(q, DEFAULT_UNITS, units...)

"""
    natural(q, system::NaturalSystem = DEFAULT_UNITS[, units::Units...])

Express `q` in terms of the produts of the given `units`, using natural conversions from `system`.
If no `units` are specified, uses the default units for `system`. 

To explicilty check that the the returned values is dimensionless and therefore of a `Real` type, set
`NoUnits`, e.g. `natural(q, sys, NoUnits)`.
"""
function natural(q, system::NaturalSystem, units::Units...)
    unit = naturalunit(q, system, units...)

    uconvert(unit, q * naturalconversion(q, system, unit))
end

natural(q, units::Units...) = natural(q, DEFAULT_UNITS, units...)

# For convenience when using custom unit systems
(system::NaturalSystem)(q, units::Units...) = natural(q, system, units...)

const unitless = QG_UNITS
