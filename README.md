# Baggins

[![Build and Test](https://github.com/alexito4/Baggins/actions/workflows/ci.yml/badge.svg)](https://github.com/alexito4/Baggins/actions/workflows/ci.yml)

🎒 My personal bag of holding for Swift extensions.

## Additions

- `Bool.toggled()`
- Safe `Collection` subscripts
- `Collection.nonEmpty` from [objc.io](https://www.objc.io/blog/2019/01/29/non-empty-collections/)
- Collection sorting with `KeyPath`
- Concurrency
  - `Task.sleep` with seconds
  - `withTimeout`
  - race `firstOf(_:or:)
  - `Task.unsafeBlocking` (careful with this one!)

- Exported [Flow](https://github.com/alexito4/Flow)
- `Sequence.toArray()`
- String `leftPadding`, `isUppercase`, `isLowercase`, `contains(anyOf:)`, `split(withWord:)`
- Exported [UnwrapOrThrow](https://github.com/alexito4/UnwrapOrThrow)
- Other stuff in `_Brewing.swift` which it probably shouldn't be used. Still brewing... 🧙‍♂️

# Author

Alejandro Martinez | https://alejandromp.com | [@alexito4](https://twitter.com/alexito4)
