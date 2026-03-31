sindices(tup::Tuple, offset = 0) = SVector{length(tup)}(eachindex(tup)) .+ offset
sindices(tup1::Tuple, tup2::Tuple) = sindices(tup1), sindices(tup2, length(tup1))

struct NaturalSystem{W, U <: DimProd, C <: DimProd, IU <: Tuple{Vararg{Units}}, IC <: Tuple}
    units::U
    conversions::C

    # Stored only for clarity - not used in internal logic
    input_units::IU
    input_converters::IC

    @doc """
        NaturalSystem(units::NTuple{N, Units}, naturally_one::Tuple) where N

    Define a natural unit system where `free_units` are the preferred units, and the quantities `naturally_one` are used to convert as needed. 
    """
    function NaturalSystem(units::Tuple{Vararg{Units}}, naturally_one::Tuple)
        free_units = filter(!=(NoUnits), units)

        basis = DimBasis(free_units..., naturally_one...)

        coordtransform = inv(basis((free_units..., naturally_one...)))

        i_free, i_natural = sindices(free_units, naturally_one)

        weights = coordtransform * basis

        conversion = DimProd(-subspace(weights, i_natural), 1, naturally_one)

        W = subspace(weights, i_free)

        dim_units = DimProd(W, NoUnits, free_units)
        
        U = typeof(dim_units)
        C = typeof(conversion)

        IU = typeof(units)
        IC = typeof(naturally_one)

        new{W, U, C, IU, IC}(dim_units, conversion, units, naturally_one)
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

function Base.show(io::IO, system::NaturalSystem)
    print(io, "NaturalSystem(", system.input_units, ", ", system.input_converters, ")")
end