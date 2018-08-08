import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// A very dirty hack to get the latest version until the package `pub_client`
/// gets updated to dart 2.0
class PubClient {
  Future<Package> getPackage(String name) async {
    final Map json = jsonDecode(
        (await http.get('https://pub.dartlang.org/api/packages/gitlab')).body);

    return Package()..latest.version = json['latest']['version'] as String;
  }
}

class Package {
  final latest = new PackageVersion();
}

class PackageVersion {
  String version;
}
