## Unreleased
### Added
- Added Squeel compatibility mode that allows `select`, `order`, `joins`, `group`, `where`, and `having` to accept DSL blocks.
- Added the ability to query tables that aren't backed by Active Record models.
- Added `BabySqueel::[]`, which provides a `BabySqueel::Relation` for models, or a `BabySqueel::Table` for symbols/strings.

### Changed
- Renamed `BabySqueel::Association::AliasingError` to `BabySqueel::AssociationAliasingError`.

## [0.2.2] - 2015-03-30
### Added
- Support for `group` (`grouping`) and `having` (`when_having`).
- Support for sifters.
- Added `quoted` and `sql` helpers for quoting strings and SQL literals.
- More descriptive error messages when a column or association is not found.

### Fixed
- `Arel::Nodes::Grouping` does not include `Arel::Math`, so operations like `(id + 5) + 3` would fail unexpectedly.
- Fix missing bind values When joining through associations with default scope.
- Removed `ActiveRecord::VERSION` specific handling of the `WhereChain`.

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

[Unreleased]: https://github.com/rzane/baby_squeel/compare/v0.2.2...HEAD
[0.2.2]: https://github.com/rzane/baby_squeel/compare/v0.2.1...v0.2.2
[0.2.1]: https://github.com/rzane/baby_squeel/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/rzane/baby_squeel/compare/v0.1.0...v0.2.0
