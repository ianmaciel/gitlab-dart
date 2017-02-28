Contribute to this library
==========================

You want to contribute, great!

Ideally, you create an issue describing what you want to change, and
how you would change it.
Once there is a consensus you can start working on the new feature. This avoids
work being done that won't get merged into this library.

## Setup

1. Clone the repo
2. Install grinder if you haven't already (`pub global activate grinder`)
3. Get the dependencies `pub get`
4. Start coding!

## Testing

For every change you make, please also add a test!

Make sure you run `grind test` before you submit a merge request, otherwise your
Merge Request will be rejected.

`grind test` fails if:

1. there are any warnings, hints or lint warnings in the code
2. the code is not properly formatted (run `grind format` for that)
3. the unit tests don't pass

## Code style

In general, make sure that you format your code with `dartfmt` and it should be fine.
If your code is not formatted properly, then the CI tests will fail, and your merge
request will **not** be accepted.

Please write your comments as sentences, ending with a period:

```dart
/// This function does foo.
goodComment() {}

/// function does foo
badComment() {}
```