part of exitlive.gitlab;

class CommitsApi {
  final GitLab _gitLab;
  final ProjectsApi _project;

  CommitsApi(this._gitLab, this._project);

  Future<Commit> get(String sha) async {
    final uri = _project._buildUri(['repository', 'commits', '$sha']);

    final Map json = await _gitLab._request(uri);

    return new Commit.fromJson(json);
  }

  Future<List<Commit>> list({String refName, DateTime since, DateTime until, int page, int perPage}) async {
    final queryParameters = <String, dynamic>{};

    if (refName != null) queryParameters['ref_name'] = refName;
    if (since != null) queryParameters['since'] = _formatDate(since);
    if (until != null) queryParameters['until'] = _formatDate(until);

    final uri =
        _project._buildUri(['repository', 'commits'], queryParameters: queryParameters, page: page, perPage: perPage);

    final List<Map> jsonList = await _gitLab._request(uri);

    return jsonList.map((json) => new Commit.fromJson(json)).toList();
  }
}

class Commit {
  final Map originalJson;

  Commit.fromJson(this.originalJson);

  String get id => originalJson['id'];
  String get shortId => originalJson['short_id'];
  String get title => originalJson['title'];
  String get message => originalJson['message'];
  String get status => originalJson['status'];
  DateTime get committedDate => DateTime.parse(originalJson['committed_date']);

  @override
  String toString() => 'Commit id#$id ($title)';
}
