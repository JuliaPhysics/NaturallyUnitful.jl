sindices(tup::Tuple, offset = 0) = SVector{length(tup)}(eachindex(tup)) .+ offset
sindices(tup1::Tuple, tup2::Tuple) = sindices(tup1), sindices(tup2, length(tup1))

struct NaturalSystem{W, C <: DimProd, U <: DimProd}
    conversions::C
    units::U

    @doc """
        NaturalSystem(units::NTuple{N, Units}, naturally_one::Tuple) where N

    Define a natural unit system where `free_units` are the preferred units, and the quantities `naturally_one` are used to convert as needed. 
    """
    function NaturalSystem(units::NTuple{N, Units}, naturally_one::Tuple) where N
        free_units = filter(!=(NoUnits), units)

        basis = DimBasis(free_units..., naturally_one...)

        coordtransform = inv(basis((free_units..., naturally_one...)))

        i_free, i_natural = sindices(free_units, naturally_one)

        weights = coordtransform * basis

        conversion = DimProd(-subspace(weights, i_natural), 1, naturally_one)

        free_weights = subspace(weights, i_free)

        dim_units = DimProd(free_weights, NoUnits, free_units)

        new{free_weights, typeof(conversion), typeof(dim_units)}(conversion, dim_units)
    end
end

"""
    NaturalSystem(naturally_one...[; unit])

Define a natural unit system with at most one `unit`, and the quantities `naturally_one` used to convert as needed. 
"""
NaturalSystem(naturally_one...; unit::Units = NoUnits) = NaturalSystem((unit,), naturally_one)

weights(::NaturalSystem{W}) where W = W

naturalconversion(q, system::NaturalSystem) = system.conversions(q)
naturalconversion(q, system::NaturalSystem, unit) = naturalconversion(q, system) / naturalconversion(unit, system)