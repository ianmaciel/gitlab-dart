## 0.6.0

- Extended API for Issues (Add, Update, Delete).
- Extended API for Merge Requests (Add, Update, Delete).
- Introduced Releases API for Releases.

## 0.5.0

- Introduced Notes API for Issues.
- Introduced Discussion API for Issues.
- Added assumeUtf8 to GitLab (optional, but activated by default) to parse responses correctly.

## 0.4.2

- Upgrade dependencies

## 0.4.1

- Fix type casting issue in issues.closedByMergeRequest()

## 0.4.0

- Rename the `Build` class to `Job` in alignment with the GitLab API.
- Add tests for .list() requests due to regression bug.

## 0.3.0

- Make changes for dart 2.0.0 release.

## 0.2.3

- Broaden the `intl` dependency to include `0.15.x`

## 0.2.2

- Broaden the SDK restriction to include everything up to `2.0.0`.

## 0.2.1

- Rename merge request get parameter to iid (was id before)

## 0.2.0

- Switch to API version v4

## 0.1.3

- Add labels to the merge requests
- Add tests for merge requests

## 0.1.2

-  Introduce `commit.createdAt`

## 0.1.1

- Add proper testing and refactor code base a bit

## 0.1.0

First version.

Introduces basic commands and most of the properties of the most important entities