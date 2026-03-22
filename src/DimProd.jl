struct DimProd{N, D, T, V <: NTuple{N, Any}} <: DimFunc{N, D}
    neutral::T
    factors::V

    DimProd(names::DimNames{N}, neutral::T, factors::V) where {N, T, V} = new{N, names, T, V}(neutral, factors)
end

function DimProd(weights::DimBasis, init, units)
    factors = map(eachelem(weights)) do weight
        mapreduce(^, *, units, weight; init)
    end

    DimProd(dimnames(weights), init, Tuple(factors))
end

Base.getindex(f::DimProd, i) = f.factors[i]
Base.getindex(f::DimProd, ::Nothing) = f.neutral

(f::DimProd)(dim::Dimension) = getdim(f, name(dim)) ^ power(dim)
(f::DimProd)(dimensionful) = prod(f.(eachdim(dimensionful)); init = f.neutral)
