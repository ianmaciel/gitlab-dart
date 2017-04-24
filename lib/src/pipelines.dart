part of exitlive.gitlab;

/// The documentation for this API is here: https://docs.gitlab.com/ee/api/builds.html
class PipelinesApi {
  final GitLab _gitLab;
  final ProjectsApi _project;

  PipelinesApi(this._gitLab, this._project);

  Future<Pipeline> get(int id) async {
    final uri = _project.buildUri(['pipelines', '$id']);

    final Map json = await _gitLab.request(uri);

    return new Pipeline.fromJson(json);
  }

  Future<List<Pipeline>> list({int page, int perPage}) async {
    final uri = _project.buildUri(['builds'], page: page, perPage: perPage);

    final List<Map> jsonList = await _gitLab.request(uri);

    return jsonList.map((json) => new Pipeline.fromJson(json)).toList();
  }
}

class Pipeline {
  final Map originalJson;

  Pipeline.fromJson(this.originalJson);

  int get id => originalJson['id'];
  String get status => originalJson['status'];
  String get ref => originalJson['ref'];
  String get sha => originalJson['sha'];

  @override
  String toString() => 'Pipeline id#$id (Ref: $ref)';
}
