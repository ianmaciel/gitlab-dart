part of exitlive.gitlab;

class ProjectsApi {
  final GitLab _gitLab;

  final int id;

  ProjectsApi(this._gitLab, this.id);

  MergeRequestsApi _mergeRequestsApi;
  MergeRequestsApi get mergeRequests => _mergeRequestsApi ??= new MergeRequestsApi(_gitLab, this);

  IssuesApi _issuesApi;
  IssuesApi get issues => _issuesApi ??= new IssuesApi(_gitLab, this);

  SnippetsApi _snippetsApi;
  SnippetsApi get snippets => _snippetsApi ??= new SnippetsApi(_gitLab, this);

  CommitsApi _commitsApi;
  CommitsApi get commits => _commitsApi ??= new CommitsApi(_gitLab, this);

  BuildsApi _buildsApi;
  BuildsApi get builds => _buildsApi ??= new BuildsApi(_gitLab, this);

  PipelinesApi _pipelinesApi;
  PipelinesApi get pipelines => _pipelinesApi ??= new PipelinesApi(_gitLab, this);

  @visibleForTesting
  Uri buildUri(Iterable<String> pathSegments, {Map<String, dynamic> queryParameters, int page, int perPage}) =>
      _gitLab.buildUri(['projects', '$id']..addAll(pathSegments),
          queryParameters: queryParameters, page: page, perPage: perPage);
}
