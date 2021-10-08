extension JsonMap on Map<dynamic, dynamic> {
  Map<String, dynamic>? getJsonMap(String key) =>
      this[key] is Map<String, dynamic>
          ? this[key] as Map<String, dynamic>?
          : <String, dynamic>{};

  int? getIntOrNull(String key) => this[key] is int ? this[key] as int : null;
  int getIntOr(String key, int defaultValue) =>
      getIntOrNull(key) ?? defaultValue;

  String? getStringOrNull(String key) =>
      this[key] is String ? this[key] as String : null;
  String getStringOr(String key, String defaultValue) =>
      getStringOrNull(key) ?? defaultValue;

  bool? getBoolOrNull(String key) =>
      this[key] is bool ? this[key] as bool? : null;
  bool getBoolOr(String key, bool defaultValue) =>
      getBoolOrNull(key) ?? defaultValue;

  DateTime? getISODateTimeOrNull(String key) => this[key] is String
      ? DateTime.tryParse(this[key] as String) ?? null
      : null;
  DateTime getISODateTimeOr(String key, DateTime defaultValue) =>
      getISODateTimeOrNull(key) ?? defaultValue;
}
