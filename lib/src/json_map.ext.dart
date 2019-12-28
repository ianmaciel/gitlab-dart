extension JsonMap on Map<String, dynamic> {
  Map<String, dynamic> getJsonMap(String key) =>
      this[key] is Map<String, dynamic>
          ? this[key] as Map<String, dynamic>
          : <String, dynamic>{};

  List<T> mapJsonList<T>(String key, T Function(Map<String, dynamic>) map) {
    if (this[key] is List) {
      return (this[key] as List)
          .map((x) => x is Map<String, dynamic> ? map(x) : null)
          .where((x) => x != null)
          .toList();
    } else {
      return <T>[];
    }
  }

  int getIntOrNull(String key) => getIntOr(key, null);
  int getIntOr(String key, int defaultValue) =>
      this[key] is int ? this[key] as int : defaultValue;

  String getStringOrNull(String key) => getStringOr(key, null);
  String getStringOr(String key, String defaultValue) =>
      this[key] is String ? this[key] as String : defaultValue;

  bool getBoolOrNull(String key) => getBoolOr(key, null);
  bool getBoolOr(String key, bool defaultValue) =>
      this[key] is bool ? this[key] as bool : defaultValue;

  DateTime getISODateTimeOrNull(String key) => getISODateTimeOr(key, null);
  DateTime getISODateTimeOr(String key, DateTime defaultValue) =>
      this[key] is String
          ? DateTime.tryParse(this[key] as String) ?? defaultValue
          : defaultValue;
}
