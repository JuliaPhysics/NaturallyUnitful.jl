"""
    struct NaturalDimensionError <: Exception
Natural dimensions are inconsistent for the attempted operation.
"""
struct NaturalDimensionError <: Exception
    q
    units
    system
end

function Base.showerror(io::IO, e::NaturalDimensionError)
    print(io, "NaturalDimensionError: $(e.q) is not dimensionally compatible with $(e.units) in system $(e.system).")
end
