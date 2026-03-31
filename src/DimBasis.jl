const Q = Rational{Int}
const Components{N, M, L} = SMatrix{N, M, Q, L}

struct DimBasis{N, M, D, L} <: DimFunc{N, D}
    components::Components{M, N, L}

    DimBasis(names::DimNames{N}, components::Components{M, N, L}) where {N, M, L} = new{N, M, names, L}(components)
end

DimBasis(names::DimNames{N}, components) where N = DimBasis(names, Components{N, N}(components))
DimBasis(names::Symbol...) = DimBasis(names, I)
DimBasis(dimensionful...) = DimBasis(dimnames(dimensionful...)...)

outdim(::DimBasis{N, M}) where {N, M} = M

Base.getindex(basis::DimBasis, i) = basis.components[:, i]
Base.getindex(basis::DimBasis, ::Nothing) = @SVector zeros(Q, outdim(basis))

eachelem(basis::DimBasis) = eachcol(basis.components)

Base.:*(M, basis::DimBasis) = DimBasis(dimnames(basis), M * basis.components)
Base.:-(basis::DimBasis) = DimBasis(dimnames(basis), -basis.components)
subspace(basis::DimBasis, i) = DimBasis(dimnames(basis), basis.components[i, :])

(basis::DimBasis)(dim::Dimension) = getdim(basis, dim) * power(dim)
(basis::DimBasis)(dimensionful) = sum(basis, eachdim(dimensionful); init = basis[nothing])
(basis::DimBasis)(dimensionfuls::Tuple) = hcat(basis.(dimensionfuls)...)

"""
    exact_ldiv(M, v)

Solve the overconstrained matrix problem `M*x = v` exactly, assuming a solution `x` exists.
"""
function exact_ldiv(M, v)
    subspace = axes(M, 2)
    
    M[subspace, :] \ v[subspace]
end