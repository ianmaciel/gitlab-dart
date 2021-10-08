part of exitlive.gitlab;

enum MilestoneState { active, closed }

class MilestonesApi {
  final GitLab _gitLab;
  final ProjectsApi _project;

  MilestonesApi(this._gitLab, this._project);

  /// Retrieves the list of milestones.
  ///
  /// See https://docs.gitlab.com/ee/api/milestones.html#list-project-milestones
  Future<List<Milestone>> list({
    MilestoneState? state,
    String? title,
    String? search,
    bool? includeParentMilestones,
  }) async {
    final queryParameters = <String, dynamic>{};

    if (state != null) queryParameters['state'] = enumToString(state);
    if (title != null) queryParameters['title'] = title;
    if (search != null) queryParameters['search'] = search;
    if (includeParentMilestones != null)
      queryParameters['includeParentMilestones'] =
          includeParentMilestones.toString();

    final uri = _project.buildUri(
      ['milestones'],
      queryParameters: queryParameters,
    );

    final List<Map<dynamic, dynamic>> jsonList =
        _responseToList(await _gitLab.request(uri));

    return jsonList.map((json) => new Milestone.fromJson(json)).toList();
  }
}

class Milestone {
  Milestone.fromJson(Map<dynamic, dynamic> milestone)
      : id = milestone["id"] as int,
        iid = milestone["iid"] as int,
        projectId = milestone["project_id"] as int,
        title = milestone.getStringOr("title", ''),
        description = milestone.getStringOr("description", ''),
        state = enumFromString(
            MilestoneState.values, milestone.getStringOrNull("state")),
        createdAt = milestone.getISODateTimeOrNull("created_at"),
        updatedAt = milestone.getISODateTimeOrNull("updated_at"),
        dueDate = milestone.getISODateTimeOrNull("due_date"),
        startDate = milestone.getISODateTimeOrNull("start_date"),
        webUrl = milestone.getStringOr("web_url", '');

  static List<Milestone?>? fromJsonList(List? milestones) => milestones
      ?.map((m) => m is Map<String, dynamic> ? Milestone.fromJson(m) : null)
      .whereNotNull()
      .toList();

  int id;
  int iid;
  int projectId;
  String title;
  String description;
  MilestoneState? state;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? dueDate;
  DateTime? startDate;
  String webUrl;
}
