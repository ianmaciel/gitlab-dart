part of exitlive.gitlab;

/// If you have an enum like `enum Foo { foo, bar }` calling this function will
/// return the name of the value.
///
/// Eg.:
///     _enumToString(Foo.bar); // => 'bar'
@visibleForTesting
String enumToString(dynamic enumValue) {
  final value = enumValue.toString().split('.').last;
  value.replaceAllMapped(
      new RegExp(r'([A-Z])'), (match) => '_${match.group(1)!.toLowerCase()}');
  return value;
}

/// If you have an enum like `enum Foo { foo, bar }` calling this function will
/// look for the value name of the enum an return the enum value if found.
/// The function will return null if the input value is not in enumValues
///
/// Eg.:
///     _enumFromString(Foo.values, 'bar'); // => 'Foo.bar'
///     _enumFromString(Foo.values, '42'); // => 'null'
///     _enumFromString(Foo.values, null); // => 'null'
@visibleForTesting
T? enumFromString<T>(List<T> enumValues, String? value) {
  if (value == null) return null;
  return enumValues.singleWhereOrNull(
      (v) => v?.toString().split('.')[1].toLowerCase() == value.toLowerCase());
}

final _formatter = new DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");

String _formatDate(DateTime date) => _formatter.format(date);

List<Map> _responseToList(dynamic response) => (response as List).cast<Map>();

Map<String, dynamic> _encodeAssigneeIds(List<int> ids) {
  return ids.isEmpty
      ? {"assignee_ids": ""}
      : {"assignee_ids[]": ids.map((id) => id.toString())};
}
