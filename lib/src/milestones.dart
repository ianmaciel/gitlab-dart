part of exitlive.gitlab;

enum MilestoneState { active, closed }

class Milestone {
  Milestone.fromJson(Map<String, dynamic> milestone)
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
