part of exitlive.gitlab;

class IssuesApi {
  final GitLab _gitLab;
  final ProjectsApi _project;

  IssuesApi(this._gitLab, this._project);

  Future<Issue> get(int id) async {
    final uri = _project.buildUri(['issues', '$id']);

    final json = await _gitLab.request(uri) as Map?;

    return new Issue.fromJson(json);
  }

  Future<Issue> create(Issue issue) async {
    // TODO fix me, conplete with issues properties
    final Uri uri = _project.buildUri([
      'issues'
    ], queryParameters: {
      "title": issue.title,
      "description": issue.description,
    });

    final json = await _gitLab.request(uri, method: HttpMethod.post) as Map?;

    return new Issue.fromJson(json);
  }

  Future<List<Issue>> closedByMergeRequest(int mergeRequestIid,
      {int? page, int? perPage}) async {
    final uri = _project.buildUri(
      ['merge_requests', '$mergeRequestIid', 'closes_issues'],
      page: page,
      perPage: perPage,
    );

    final jsonList = (await _gitLab.request(uri) as List).cast<Map>();

    return jsonList.map((json) => new Issue.fromJson(json)).toList();
  }

  Future<List<Issue>> list(
      {IssueState? state,
      IssueOrderBy? orderBy,
      IssueSort? sort,
      String? milestone,
      List<String>? labels,
      int? page,
      int? perPage}) async {
    final queryParameters = <String, dynamic>{};

    if (state != null) queryParameters['state'] = _enumToString(state);
    if (orderBy != null) queryParameters['order_by'] = _enumToString(orderBy);
    if (sort != null) queryParameters['sort'] = _enumToString(sort);
    if (milestone != null) queryParameters['milestone'] = milestone;
    if (labels != null) queryParameters['labels'] = labels.join(',');

    final uri = _project.buildUri(['issues'],
        queryParameters: queryParameters, page: page, perPage: perPage);

    final jsonList = _responseToList(await _gitLab.request(uri));

    return jsonList.map((json) => new Issue.fromJson(json)).toList();
  }
}

enum IssueState { opened, closed }
enum IssueOrderBy { createdAt, updatedAt }
enum IssueSort { asc, desc }

class Issue {
  Map? originalJson;
  Issue() {
    originalJson = <String, dynamic>{};
  }
  Issue.fromJson(this.originalJson);

  int? get projectId => originalJson!['project_id'] as int?;
  int? get id => originalJson!['id'] as int?;
  int? get iid => originalJson!['iid'] as int?;

  String? get title => originalJson!['title'] as String?;
  set title(String? value) => originalJson!['title'] = value;
  String? get description => originalJson!['description'] as String?;
  set description(String? value) => originalJson!['description'] = value;

  String? get state => originalJson!['state'] as String?;
  List<String> get labels => (originalJson!['labels'] as List).cast<String>();
  String? get webUrl => originalJson!['web_url'] as String?;

  DateTime get createdAt =>
      DateTime.parse(originalJson!['created_at'] as String);
  DateTime get updatedAt =>
      DateTime.parse(originalJson!['updated_at'] as String);

  bool? get subscribed => originalJson!['subscribed'] as bool?;
  int? get userNotesCount => originalJson!['user_notes_count'] as int?;
  DateTime? get dueDate => originalJson!['due_date'] == null
      ? null
      : DateTime.parse(originalJson!['due_date'] as String);

  bool? get confidential => originalJson!['confidential'] as bool?;
  int? get weight => originalJson!['weight'] as int?;

  @override
  String toString() => 'Issue id#$id iid#$iid ($title)';
}
