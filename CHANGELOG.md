## [Unreleased]
### Plans
- Support for `group` and `having`.

## [0.2.1] - 2015-03-27
### Added
- Support for subqueries.

### Fixed
- Some Arel nodes did not have access to `as` expressions.

## [0.2.0] - 2015-03-25
### Added
- References to aliased joins in a `select`, `where`, or `order` expression now use the aliased table name.

### Changed
- Rely on `ActiveRecord::Relation#join_sources` for the implicit construction of join nodes, rather than using the `ActiveRecord::Associations::JoinDependency` directly.

### Fixed

- Associations referencing the same table weren't being aliased.

## [0.1.0] - 2015-03-16
### Added
- Initial support for selects, orders, wheres, and joins.

[Unreleased]: https://github.com/rzane/baby_squeel/compare/v0.2.1...HEAD
[0.2.1]: https://github.com/rzane/baby_squeel/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/rzane/baby_squeel/compare/v0.1.0...v0.2.0
