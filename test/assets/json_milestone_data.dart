// example data from https://docs.gitlab.com/ee/api/milestones.html
const milestones = '''
[
  {
    "id": 12,
    "iid": 3,
    "project_id": 16,
    "title": "10.0",
    "description": "Version",
    "due_date": "2013-11-29",
    "start_date": "2013-11-10",
    "state": "active",
    "updated_at": "2013-10-02T09:24:18Z",
    "created_at": "2013-10-02T09:24:18Z",
    "expired": false
  },
  {
    "id": 13,
    "iid": 4,
    "project_id": 16,
    "title": "10.0",
    "description": "Version",
    "due_date": "2013-11-29",
    "start_date": "2013-11-10",
    "state": "active",
    "updated_at": "2013-10-02T09:24:18Z",
    "created_at": "2013-10-02T09:24:18Z",
    "expired": false
  }
]
''';

const milestone = '''
{
  "id": 12,
  "iid": 3,
  "project_id": 16,
  "title": "10.0",
  "description": "Version",
  "due_date": "2013-11-29",
  "start_date": "2013-11-10",
  "state": "active",
  "updated_at": "2013-10-02T09:24:18Z",
  "created_at": "2013-10-02T09:24:18Z",
  "expired": false
}
''';
