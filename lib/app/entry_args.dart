import 'dart:convert';

/// Dart 入口参数。
///
/// 对应原生侧 `FlutterArgsUtils.createEntryArgs()` 拼出的 JSON：包名、版本、env 等。
/// 启动时由 `FlutterEngineGroup.Options.setDartEntrypointArgs(...)` 传入，
/// `main(List<String> args)` 第一个元素就是该 JSON 字符串。
class EntryArgs {
  final String env; // DEBUG / RELEASE
  final String appVersion;
  final String buildVersion;
  final String packageName;

  const EntryArgs({
    this.env = 'DEBUG',
    this.appVersion = '',
    this.buildVersion = '',
    this.packageName = '',
  });

  factory EntryArgs.fromJson(Map<String, dynamic> json) => EntryArgs(
        env: (json['env'] as String?) ?? 'DEBUG',
        appVersion: (json['appVersion'] as String?) ?? '',
        buildVersion: (json['buildVersion'] as String?) ?? '',
        packageName: (json['packageName'] as String?) ?? '',
      );

  static EntryArgs parse(List<String> args) {
    if (args.isEmpty) return const EntryArgs();
    try {
      final map = jsonDecode(args.first) as Map<String, dynamic>;
      return EntryArgs.fromJson(map);
    } catch (_) {
      return const EntryArgs();
    }
  }
}
