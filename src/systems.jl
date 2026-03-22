# Useful Conversions
const MOL_CONVERSION = 6.022_140_76e23 / Unitful.mol
const COMMON_CONVERSIONS = Unitful.c, Unitful.ħ, Unitful.k, 4π*Unitful.ϵ0, MOL_CONVERSION

# Standard Unit System
const PARTICLE_UNITS = NaturalSystem(COMMON_CONVERSIONS..., unit = Unitful.eV)
const QG_UNITS = NaturalSystem(COMMON_CONVERSIONS..., Unitful.G)

# Default
const DEFAULT_UNITS = PARTICLE_UNITS