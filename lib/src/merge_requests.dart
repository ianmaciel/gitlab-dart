part of exitlive.gitlab;

class MergeRequestsApi {
  final GitLab _gitLab;
  final ProjectsApi _project;

  MergeRequestsApi(this._gitLab, this._project);

  Future<MergeRequest> get(int id) async {
    final uri = _project.buildUri(['merge_requests', '$id']);

    final Map json = await _gitLab.request(uri);

    return new MergeRequest.fromJson(json);
  }

  Future<List<MergeRequest>> list(
      {MergeRequestState state,
      MergeRequestOrderBy orderBy,
      MergeRequestSort sort,
      int page,
      int perPage,
      List<int> iids}) async {
    final queryParameters = <String, dynamic>{};

    if (state != null) queryParameters['state'] = _enumToString(state);
    if (orderBy != null) queryParameters['order_by'] = _enumToString(orderBy);
    if (sort != null) queryParameters['sort'] = _enumToString(sort);
    if (iids != null && iids.isNotEmpty) {
      queryParameters['iid[]'] = iids.map((iid) => iid.toString());
    }

    final uri = _project.buildUri(['merge_requests'], queryParameters: queryParameters, page: page, perPage: perPage);

    final List<Map> jsonList = await _gitLab.request(uri);

    return jsonList.map((json) => new MergeRequest.fromJson(json)).toList();
  }
}

enum MergeRequestState { merged, opened, closed }
enum MergeRequestOrderBy { createdAt, updatedAt }
enum MergeRequestSort { asc, desc }

class MergeRequest {
  final Map originalJson;

  MergeRequest.fromJson(this.originalJson);

  int get id => originalJson['id'];
  int get iid => originalJson['iid'];
  String get targetBranch => originalJson['target_branch'];
  String get sourceBranch => originalJson['source_branch'];
  int get projectId => originalJson['project_id'];
  String get title => originalJson['title'];
  String get state => originalJson['state'];
  List<String> get labels => originalJson['labels'];
  int get upvotes => originalJson['upvotes'];
  int get downvotes => originalJson['downvotes'];
  String get description => originalJson['description'];
  String get webUrl => originalJson['web_url'];

  @override
  String toString() => 'MergeRequest id#$id iid#$iid ($title)';
}
