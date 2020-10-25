part of exitlive.gitlab;

class MergeRequestsApi {
  final GitLab _gitLab;
  final ProjectsApi _project;

  MergeRequestsApi(this._gitLab, this._project);

  Future<MergeRequest> get(int iid) async {
    final uri = _project.buildUri(['merge_requests', '$iid']);

    final json = await _gitLab.request(uri) as Map;

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

    if (state != null) queryParameters['state'] = enumToString(state);
    if (orderBy != null) queryParameters['order_by'] = enumToString(orderBy);
    if (sort != null) queryParameters['sort'] = enumToString(sort);
    if (iids != null && iids.isNotEmpty) {
      queryParameters['iids[]'] = iids.map((iid) => iid.toString());
    }

    final uri = _project.buildUri(['merge_requests'],
        queryParameters: queryParameters, page: page, perPage: perPage);

    final jsonList = _responseToList(await _gitLab.request(uri));

    return jsonList.map((json) => new MergeRequest.fromJson(json)).toList();
  }

  /// Creates a new merge request.
  ///
  /// See https://docs.gitlab.com/ee/api/merge_requests.html#create-mr
  Future<MergeRequest> add(
    String title,
    String sourceBranch,
    String targetBranch, {
    List<int> assigneeIds,
    String description,
    int targetProjectId,
    List<String> labels,
    int milestoneId,
    bool removeSourceBranch,
    bool allowCollaboration,
    bool squash,
  }) async {
    final queryParameters = <String, dynamic>{
      "title": title,
      "source_branch": sourceBranch,
      "target_branch": targetBranch,
      if (assigneeIds != null) ..._encodeAssigneeIds(assigneeIds),
      if (description != null) "description": description,
      if (targetProjectId != null) "target_project_id": targetProjectId,
      if (labels != null) "labels": labels.join(','),
      if (milestoneId != null) "milestone_id": milestoneId,
      if (removeSourceBranch != null)
        "remove_source_branch": removeSourceBranch.toString(),
      if (allowCollaboration != null)
        "allow_collaboration": allowCollaboration.toString(),
      if (squash != null) "squash": squash.toString(),
    };

    final uri =
        _project.buildUri(['merge_requests'], queryParameters: queryParameters);

    final json = await _gitLab.request(
      uri,
      method: HttpMethod.post,
    ) as Map<String, dynamic>;

    return MergeRequest.fromJson(json);
  }

  /// Updates an existing merge request.
  ///
  /// See https://docs.gitlab.com/ee/api/merge_requests.html#update-mr
  Future<MergeRequest> update(
    mergeRequestIid, {
    String title,
    String sourceBranch,
    String targetBranch,
    List<int> assigneeIds,
    String description,
    int targetProjectId,
    List<String> labels,
    int milestoneId,
    bool removeSourceBranch,
    bool allowCollaboration,
    bool squash,
  }) async {
    final queryParameters = <String, dynamic>{
      if (title != null) "title": title,
      if (sourceBranch != null) "source_branch": sourceBranch,
      if (targetBranch != null) "target_branch": targetBranch,
      if (assigneeIds != null) ..._encodeAssigneeIds(assigneeIds),
      if (description != null) "description": description,
      if (targetProjectId != null) "target_project_id": targetProjectId,
      if (labels != null) "labels": labels.join(','),
      if (milestoneId != null) "milestone_id": milestoneId,
      if (removeSourceBranch != null)
        "remove_source_branch": removeSourceBranch.toString(),
      if (allowCollaboration != null)
        "allow_collaboration": allowCollaboration.toString(),
      if (squash != null) "squash": squash.toString(),
    };

    final uri = _project.buildUri(
      ['merge_requests', mergeRequestIid.toString()],
      queryParameters: queryParameters,
    );

    final json = await _gitLab.request(
      uri,
      method: HttpMethod.put,
    ) as Map<String, dynamic>;

    return MergeRequest.fromJson(json);
  }

  /// Deletes an existing merge request.
  ///
  /// See https://docs.gitlab.com/ee/api/merge_requests.html#delete-a-merge-request
  Future<void> delete(int mergeRequestIid) async {
    final uri = _project.buildUri(
      ['merge_requests', mergeRequestIid.toString()],
    );

    await _gitLab.request(uri, method: HttpMethod.delete, asJson: false);
  }
}

enum MergeRequestState { merged, opened, closed }
enum MergeRequestOrderBy { createdAt, updatedAt }
enum MergeRequestSort { asc, desc }

class MergeRequest {
  final Map originalJson;

  MergeRequest.fromJson(this.originalJson);

  int get id => originalJson['id'] as int;

  int get iid => originalJson['iid'] as int;

  String get targetBranch => originalJson['target_branch'] as String;

  String get sourceBranch => originalJson['source_branch'] as String;

  int get projectId => originalJson['project_id'] as int;

  String get title => originalJson['title'] as String;

  String get state => originalJson['state'] as String;

  List<String> get labels => (originalJson['labels'] as List).cast<String>();

  int get upvotes => originalJson['upvotes'] as int;

  int get downvotes => originalJson['downvotes'] as int;

  String get description => originalJson['description'] as String;

  String get webUrl => originalJson['web_url'] as String;

  User get author => originalJson['author'] == null
      ? null
      : User.fromJson(originalJson['author'] as Map<String, dynamic>);

  List<User> get assignees => originalJson['assignees'] == null
      ? []
      : (originalJson['assignees'] as List)
          .map((json) => User.fromJson(json as Map<String, dynamic>))
          .toList(growable: false);

  @override
  String toString() => 'MergeRequest id#$id iid#$iid ($title)';
}
