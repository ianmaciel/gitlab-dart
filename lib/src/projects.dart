part of exitlive.gitlab;

class ProjectsApi {
  final GitLab _gitLab;

  // Id must be nullable so we can create ProjectsApi without a project (to
  // list projects).
  int? id;

  ProjectsApi(this._gitLab, this.id);

  MergeRequestsApi? _mergeRequestsApi;

  MergeRequestsApi get mergeRequests =>
      _mergeRequestsApi ??= new MergeRequestsApi(_gitLab, this);

  IssuesApi? _issuesApi;

  IssuesApi get issues => _issuesApi ??= new IssuesApi(_gitLab, this);

  /// Get the [IssueNotesApi] for an [issue].
  ///
  /// This call doesn't do anything by itself, other than return the
  /// configured object.
  /// You can safely store the returned object and reuse it.
  IssueNotesApi issueNotes(Issue issue) => issueNotesByIid(issue.iid);

  /// Get the [IssueNotesApi] for an [issueIid].
  ///
  /// This call doesn't do anything by itself, other than return the
  /// configured object.
  /// You can safely store the returned object and reuse it.
  IssueNotesApi issueNotesByIid(int issueIid) => IssueNotesApi(
        _gitLab,
        this,
        issueIid,
      );

  /// Get the [IssueDiscussionsApi] for an [issue].
  ///
  /// This call doesn't do anything by itself, other than return the
  /// configured object.
  /// You can safely store the returned object and reuse it.
  IssueDiscussionsApi issueDiscussions(Issue issue) =>
      issueDiscussionsByIid(issue.iid);

  /// Get the [IssueDiscussionsApi] for an [issueIid].
  ///
  /// This call doesn't do anything by itself, other than return the
  /// configured object.
  /// You can safely store the returned object and reuse it.
  IssueDiscussionsApi issueDiscussionsByIid(int issueIid) =>
      IssueDiscussionsApi(
        _gitLab,
        this,
        issueIid,
      );

  SnippetsApi? _snippetsApi;

  SnippetsApi get snippets => _snippetsApi ??= new SnippetsApi(_gitLab, this);

  CommitsApi? _commitsApi;

  CommitsApi get commits => _commitsApi ??= new CommitsApi(_gitLab, this);

  JobsApi? _jobsApi;

  JobsApi get jobs => _jobsApi ??= new JobsApi(_gitLab, this);

  PipelinesApi? _pipelinesApi;

  PipelinesApi get pipelines =>
      _pipelinesApi ??= new PipelinesApi(_gitLab, this);

  ReleasesApi? _releasesApi;

  ReleasesApi get releases => _releasesApi ??= new ReleasesApi(_gitLab, this);

  MilestonesApi? _milestonesApi;

  MilestonesApi get milestones =>
      _milestonesApi ??= new MilestonesApi(_gitLab, this);

  Future<List<Project>> list(
      {bool? archived,
      int? idAfter,
      int? idBefore,
      DateTime? lastActivityAfter,
      DateTime? lastActivityBefore,
      bool? membership,
      int? minAccessLevel,
      ProjectOrderBy? orderBy,
      bool? owned,
      bool? repositoryChecksumFailed,

      /// Administrators only
      String? repositoryStorage,
      bool searchNamespaces = false,
      String? search,
      bool simple = true,
      ProjectSort sort = ProjectSort.desc,
      bool? starred,
      bool? statistics,
      String? topic,
      ProjectVisibility? visibility,

      /// Premium only
      bool? wikiChecksumFailed,

      /// Administrators only
      bool? withCustomAttributes,
      bool? withIssuesEnabled,
      bool? withMergeRequestsEnabled,
      String? withProgrammingLanguage,
      int? page,
      int? perPage}) async {
    final queryParameters = <String, dynamic>{};

    if (archived != null) queryParameters['archived'] = archived.toString();
    if (idAfter != null) queryParameters['id_after'] = idAfter.toString();
    if (idBefore != null) queryParameters['id_before'] = idBefore;
    if (lastActivityAfter != null)
      queryParameters['last_activity_after'] =
          DateFormat.yMd().format(lastActivityAfter);
    if (lastActivityBefore != null)
      queryParameters['last_activity_before'] =
          DateFormat.yMd().format(lastActivityBefore);
    if (membership != null)
      queryParameters['membership'] = membership.toString();
    if (minAccessLevel != null)
      queryParameters['min_access_level'] = minAccessLevel.toString();
    if (orderBy != null) queryParameters['order_by'] = enumToString(orderBy);
    if (owned != null) queryParameters['owned'] = owned;
    if (repositoryChecksumFailed != null)
      queryParameters['repository_checksum_failed'] = repositoryChecksumFailed;
    if (repositoryStorage != null)
      queryParameters['repository_storage'] = repositoryStorage;
    queryParameters['search_namespaces'] = searchNamespaces.toString();
    if (search != null) queryParameters['search'] = search;
    queryParameters['simple'] = simple.toString();
    queryParameters['sort'] = enumToString(sort);
    if (starred != null) queryParameters['starred'] = starred.toString();
    if (statistics != null)
      queryParameters['statistics'] = statistics.toString();
    if (topic != null) queryParameters['topic'] = topic;
    if (visibility != null)
      queryParameters['visibility'] = enumToString(visibility);
    if (wikiChecksumFailed != null)
      queryParameters['wiki_checksum_failed'] = wikiChecksumFailed.toString();
    if (withCustomAttributes != null)
      queryParameters['with_custom_attributes'] =
          withCustomAttributes.toString();
    if (withIssuesEnabled != null)
      queryParameters['with_issues_enabled'] = withIssuesEnabled.toString();
    if (withMergeRequestsEnabled != null)
      queryParameters['with_merge_requests_enabled'] =
          withMergeRequestsEnabled.toString();
    if (withProgrammingLanguage != null)
      queryParameters['with_programming_language'] = withProgrammingLanguage;

    final uri = _gitLab.buildUri(['projects'],
        queryParameters: queryParameters, page: page, perPage: perPage);

    final jsonList = _responseToList(await _gitLab.request(uri));

    return jsonList.map((json) => new Project.fromJson(json)).toList();
  }

  @visibleForTesting
  Uri buildUri(Iterable<String> pathSegments,
          {Map<String, dynamic>? queryParameters, int? page, int? perPage}) =>
      _gitLab.buildUri(['projects', '$id']..addAll(pathSegments),
          queryParameters: queryParameters, page: page, perPage: perPage);
}

enum ProjectOrderBy {
  id,
  name,
  path,
  createdAt,
  updatedAt,
  lastActivityAt,
  similarity,

  /// Administrators only.
  repositorySize,

  /// Administrators only.
  storageSize,

  /// Administrators only.
  packagesSize,

  /// Administrators only.
  wikiSize,
}

enum ProjectSort { asc, desc }
enum ProjectVisibility { public, internal, private }

class ProjectMinAccessLevel {
  /// No access (0)
  static final int noAccess = 0;

  /// Minimal access (5) (Introduced in GitLab 13.5.)
  static final int minimalAccess = 5;

  /// Guest (10)
  static final int guest = 10;

  /// Reporter (20)
  static final int reporter = 20;

  /// Developer (30)
  static final int developer = 30;

  /// Maintainer (40)
  static final int maintainer = 40;

  /// Owner (50) - Only valid to set for groups
  static final int owner = 50;
}

class Project {
  final Map? originalJson;

  Project.fromJson(this.originalJson);

  int? get id => originalJson!['id'] as int?;
  String? get description => originalJson!['description'] as String?;
  String? get defaultBranch => originalJson!['default_branch'] as String?;
  String? get sshUrlToRepo => originalJson!['ssh_url_to_repo'] as String?;
  String? get httpRrlToRepo => originalJson!['http_url_to_repo'] as String?;
  String? get webUrl => originalJson!['web_url'] as String?;
  String? get readmeUrl => originalJson!['readme_url'] as String?;
  List<String>? get topics => (originalJson!['topics'] as List).cast<String>();
  String? get name => originalJson!['name'] as String?;
  String? get nameWithNamespace =>
      originalJson!['name_with_namespace'] as String?;
  String? get path => originalJson!['path'] as String?;
  String? get pathWithNamespaceath =>
      originalJson!['path_with_namespace'] as String?;
  DateTime get createdAt =>
      DateTime.parse(originalJson!['created_at'] as String);
  DateTime get lastActivityAt =>
      DateTime.parse(originalJson!['last_activity_at'] as String);
  int get forksCount => originalJson!['forks_count'] as int;
  String? get avatarUrl => originalJson!['avatar_url'] as String?;
  int get starCount => originalJson!['star_count'] as int;
}
