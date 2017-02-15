part of exitlive.gitlab;

class IssuesApi {
  final GitLab _gitLab;
  final ProjectsApi _project;

  IssuesApi(this._gitLab, this._project);

  Future<Issue> get(int id) async {
    final uri = _project.buildUri(['issues', '$id']);

    final Map json = await _gitLab.request(uri);

    return new Issue.fromJson(json);
  }

  Future<List<Issue>> closedByMergeRequest(int mergeRequestId, {int page, int perPage}) async {
    final uri = _project.buildUri(['merge_requests', '$mergeRequestId', 'closes_issues'], page: page, perPage: perPage);

    final List<Map> jsonList = await _gitLab.request(uri);

    return jsonList.map((json) => new Issue.fromJson(json)).toList();
  }

  Future<List<Issue>> list(
      {IssueState state,
      IssueOrderBy orderBy,
      IssueSort sort,
      String milestone,
      List<String> labels,
      int page,
      int perPage}) async {
    final queryParameters = <String, dynamic>{};

    if (state != null) queryParameters['state'] = _enumToString(state);
    if (orderBy != null) queryParameters['order_by'] = _enumToString(orderBy);
    if (sort != null) queryParameters['sort'] = _enumToString(sort);
    if (milestone != null) queryParameters['milestone'] = milestone;
    if (labels != null) queryParameters['labels'] = labels.join(',');

    final uri = _project.buildUri(['issues'], queryParameters: queryParameters, page: page, perPage: perPage);

    final List<Map> jsonList = await _gitLab.request(uri);

    return jsonList.map((json) => new Issue.fromJson(json)).toList();
  }
}

enum IssueState { opened, closed }
enum IssueOrderBy { createdAt, updatedAt }
enum IssueSort { asc, desc }

class Issue {
  final Map originalJson;

  Issue.fromJson(this.originalJson);

  int get id => originalJson['id'];
  int get iid => originalJson['iid'];
  int get projectId => originalJson['project_id'];
  String get title => originalJson['title'];
  String get description => originalJson['description'];
  List<String> get labels => originalJson['labels'];
  String get webUrl => originalJson['web_url'];

  @override
  String toString() => 'Issue id#$id iid#$iid ($title)';
}
