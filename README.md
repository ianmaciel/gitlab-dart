# GitLab API

[![build status](https://gitlab.com/exitlive/gitlab-dart/badges/master/build.svg)](https://gitlab.com/exitlive/gitlab-dart/commits/master)

This is a dart library to communicate with the [GitLab API v3](https://docs.gitlab.com/ee/api/README.html).

> **This is still work in progress.** We are happy about Merge Requets!

## Installation

Simply add it to your project as a dependency:

```yaml
dependencies:
  gitlab: any
```

## Usage

```dart
main() async {
  final projectId = 123;
  final gitLab = new GitLab('secret-api-token');
  // If you have a GitLab on a different host, you can provide the hostname and scheme as well
  final gitLabProject = await gitLab.project(projectId);
  var issues = await gitLabProject.issues.list();
  print(issues.first.title);
}
```