# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-03-31

A big rework:

### Added

- Custom `NaturalSystem` type for different conversions/preferred units
    - Multiple units remaining, or none, now possible
- Unit inference in `natural` - now provide a basis of any units to convert and the appropriate powers are derived as needed
- A second builtin unit system (`QG_UNITS`/`unitless`), which includes `G=1`
- `natdims` and `naturalunit` functions for more information about conversion process

### Changed
- The default units are now called `PARTICLE_UNITS` and included converting `mol` using Avogadro's constant.
- `base` kwarg in `natural` is now positional, with multiple bases allowed

### Removed

- `unnatural` function - now incorporated into `natural` via more flexible bases
