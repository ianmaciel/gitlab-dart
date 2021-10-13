import 'dart:convert';

export 'json_issue_data.dart';
export 'json_issue_discussion_data.dart';
export 'json_issue_notes_data.dart';
export 'json_merge_requests_data.dart';
export 'json_releases_data.dart';

Map? decodeMap(String json) => jsonDecode(json) as Map?;
List? decodeList(String json) => jsonDecode(json) as List?;

const job = '''
{
  "commit": {
    "author_email": "admin@example.com",
    "author_name": "Administrator",
    "created_at": "2015-12-24T16:51:14.000+01:00",
    "id": "0ff3ae198f8601a285adcf5c0fff204ee6fba5fd",
    "message": "Test the CI integration.",
    "short_id": "0ff3ae19",
    "title": "Test the CI integration."
  },
  "coverage": null,
  "created_at": "2015-12-24T15:51:21.880Z",
  "finished_at": "2015-12-24T17:54:31.198Z",
  "artifacts_expire_at": "2016-01-23T17:54:31.198Z",
  "id": 8,
  "name": "rubocop",
  "pipeline": {
    "id": 6,
    "ref": "master",
    "sha": "0ff3ae198f8601a285adcf5c0fff204ee6fba5fd",
    "status": "pending"
  },
  "ref": "master",
  "artifacts": [],
  "runner": null,
  "stage": "test",
  "started_at": "2015-12-24T17:54:30.733Z",
  "status": "failed",
  "tag": false,
  "web_url": "https://example.com/foo/bar/-/jobs/8",
  "user": {
    "avatar_url": "http://www.gravatar.com/avatar/e64c7d89f26bd1972efa854d13d7dd61?s=80&d=identicon",
    "bio": null,
    "created_at": "2015-12-21T13:14:24.077Z",
    "id": 1,
    "linkedin": "",
    "name": "Administrator",
    "skype": "",
    "state": "active",
    "twitter": "",
    "username": "root",
    "web_url": "http://gitlab.dev/root",
    "website_url": ""
  }
}
''';

const jobs = '''
[
  {
    "commit": {
      "author_email": "admin@example.com",
      "author_name": "Administrator",
      "created_at": "2015-12-24T16:51:14.000+01:00",
      "id": "0ff3ae198f8601a285adcf5c0fff204ee6fba5fd",
      "message": "Test the CI integration.",
      "short_id": "0ff3ae19",
      "title": "Test the CI integration."
    },
    "coverage": null,
    "created_at": "2015-12-24T15:51:21.727Z",
    "finished_at": "2015-12-24T17:54:24.921Z",
    "artifacts_expire_at": "2016-01-23T17:54:24.921Z",
    "id": 6,
    "name": "rspec:other",
    "pipeline": {
      "id": 6,
      "ref": "master",
      "sha": "0ff3ae198f8601a285adcf5c0fff204ee6fba5fd",
      "status": "pending"
    },
    "ref": "master",
    "artifacts": [],
    "runner": null,
    "stage": "test",
    "started_at": "2015-12-24T17:54:24.729Z",
    "status": "failed",
    "tag": false,
    "web_url": "https://example.com/foo/bar/-/jobs/6",
    "user": {
      "avatar_url": "http://www.gravatar.com/avatar/e64c7d89f26bd1972efa854d13d7dd61?s=80&d=identicon",
      "bio": null,
      "created_at": "2015-12-21T13:14:24.077Z",
      "id": 1,
      "linkedin": "",
      "name": "Administrator",
      "skype": "",
      "state": "active",
      "twitter": "",
      "username": "root",
      "web_url": "http://gitlab.dev/root",
      "website_url": ""
    }
  },
  {
    "commit": {
      "author_email": "admin@example.com",
      "author_name": "Administrator",
      "created_at": "2015-12-24T16:51:14.000+01:00",
      "id": "0ff3ae198f8601a285adcf5c0fff204ee6fba5fd",
      "message": "Test the CI integration.",
      "short_id": "0ff3ae19",
      "title": "Test the CI integration."
    },
    "coverage": null,
    "created_at": "2015-12-24T15:51:21.802Z",
    "artifacts_file": {
      "filename": "artifacts.zip",
      "size": 1000
    },
    "artifacts": [
      {"file_type": "archive", "size": 1000, "filename": "artifacts.zip", "file_format": "zip"},
      {"file_type": "metadata", "size": 186, "filename": "metadata.gz", "file_format": "gzip"},
      {"file_type": "trace", "size": 1500, "filename": "job.log", "file_format": "raw"},
      {"file_type": "junit", "size": 750, "filename": "junit.xml.gz", "file_format": "gzip"}
    ],
    "finished_at": "2015-12-24T17:54:27.895Z",
    "artifacts_expire_at": "2016-01-23T17:54:27.895Z",
    "id": 7,
    "name": "teaspoon",
    "pipeline": {
      "id": 6,
      "ref": "master",
      "sha": "0ff3ae198f8601a285adcf5c0fff204ee6fba5fd",
      "status": "pending"
    },
    "ref": "master",
    "artifacts": [],
    "runner": null,
    "stage": "test",
    "started_at": "2015-12-24T17:54:27.722Z",
    "status": "failed",
    "tag": false,
    "web_url": "https://example.com/foo/bar/-/jobs/7",
    "user": {
      "avatar_url": "http://www.gravatar.com/avatar/e64c7d89f26bd1972efa854d13d7dd61?s=80&d=identicon",
      "bio": null,
      "created_at": "2015-12-21T13:14:24.077Z",
      "id": 1,
      "linkedin": "",
      "name": "Administrator",
      "skype": "",
      "state": "active",
      "twitter": "",
      "username": "root",
      "web_url": "http://gitlab.dev/root",
      "website_url": ""
    }
  }
]
''';
