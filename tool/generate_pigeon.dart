import 'dart:io';

Future<void> main() async {
  final result = await Process.run(
    'dart',
    <String>[
      'run',
      'pigeon',
      '--input',
      'pigeons/demo_bridge.dart',
    ],
    runInShell: true,
  );

  stdout.write(result.stdout);
  stderr.write(result.stderr);

  if (result.exitCode != 0) {
    exit(result.exitCode);
  }
}
