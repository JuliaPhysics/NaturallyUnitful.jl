using NaturallyUnitful
using Unitful
using Test

@testset "NaturallyUnitful.jl" begin
    @test natural(u"ħ^2 * c^0.5") ≈ 1
    @test unitless(u"G*ħ*c") ≈ 1
    @test natural(u"ft") ≈ natural(u"ns") rtol = 0.05
    @test natdim(10u"m") == -1
    @test natdim(u"c") == 0
    @test natural(u"q^-2") ≈ 137 rtol = 0.05

    weirdunits = NaturalSystem(2u"m/s", u"N", unit = u"kg")

    @test (@inferred natural(4u"m", weirdunits)) ≈ 1u"kg"

    @test unit(@inferred weirdunits(u"c")) == NoUnits

    @test (@inferred natural(u"G"^(-1//2), QG_UNITS, u"μg")) ≈ 21.7u"μg" rtol = 0.05

    @inferred natural(u"kg^2 / m", PARTICLE_UNITS)

    @test dimless(1u"c") ≈ 1
    @test dimless(Float32, 1u"m/s") isa Float32
    @test_throws MethodError dimless(1u"kg")

    @inferred dimless(1u"c")
    @inferred dimless(Float32, 0.1u"nC")
end
