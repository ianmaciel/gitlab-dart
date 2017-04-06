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


# Contributor Code of Conduct

As contributors and maintainers of this project, we pledge to respect all people
who contribute through reporting issues, posting feature requests, updating
documentation, submitting pull requests or patches, and other activities.

We are committed to making participation in this project a harassment-free
experience for everyone, regardless of level of experience, gender, gender
identity and expression, sexual orientation, disability, personal appearance,
body size, race, ethnicity, age, or religion.

Examples of unacceptable behavior by participants include the use of sexual
language or imagery, derogatory comments or personal attacks, trolling, public
or private harassment, insults, or other unprofessional conduct.

Project maintainers have the right and responsibility to remove, edit, or reject
comments, commits, code, wiki edits, issues, and other contributions that are
not aligned to this Code of Conduct. Project maintainers who do not follow the
Code of Conduct may be removed from the project team.

Instances of abusive, harassing, or otherwise unacceptable behavior may be
reported by opening an issue or contacting one or more of the project
maintainers.

This Code of Conduct is adapted from the Contributor Covenant, version 1.0.0,
available from http://contributor-covenant.org/version/1/0/0/