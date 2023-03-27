import 'package:build/build.dart';
import 'package:pubspec_parse/pubspec_parse.dart';

Builder buildPubspec([BuilderOptions? options]) => _PubspecBuilder(
    (options?.config['output'] as String?) ?? 'lib/src/pubspec.dart');

class _PubspecBuilder implements Builder {
  final String output;

  _PubspecBuilder(this.output);

  @override
  Future<void> build(BuildStep buildStep) async {
    final assetId = AssetId(buildStep.inputId.package, 'pubspec.yaml');

    if (assetId != buildStep.inputId) {
      return;
    }

    final content = await buildStep.readAsString(assetId);

    final pubspec = Pubspec.parse(content, sourceUrl: assetId.uri);

    if (pubspec.description == null || pubspec.version == null) {
      throw StateError(
          'pubspec.yaml does not have a description or version defined.');
    }

    await buildStep.writeAsString(buildStep.allowedOutputs.single, '''
// Generated code. Do not modify.
const packageName = '${pubspec.name}';
const packageDescription = '${pubspec.description}';
const packageVersion = '${pubspec.version}';
''');
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        'pubspec.yaml': [output],
      };
}
