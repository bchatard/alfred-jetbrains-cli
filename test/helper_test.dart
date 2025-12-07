import 'dart:io';

import 'package:alfred_jetbrains_cli/helper.dart';
import 'package:test/test.dart';

void main() {
  group('parsePath helper', () {
    test('replaces tilde with HOME', () {
      final home = Platform.environment['HOME'];
      if (home != null) {
        expect(parsePath('~/Documents'), '$home/Documents');
        expect(parsePath('~/'), '$home/');
      }
    });

    test('returns path unchanged when no tilde', () {
      expect(parsePath('/absolute/path'), '/absolute/path');
      expect(parsePath('relative/path'), 'relative/path');
    });

    test('handles multiple tildes', () {
      final home = Platform.environment['HOME'];
      if (home != null) {
        expect(parsePath('~/test/~/another'), '$home/test/$home/another');
      }
    });

    test('handles empty string', () {
      expect(parsePath(''), '');
    });
  });

  group('helper constants', () {
    test('packageName is defined', () {
      expect(packageName, 'alfred_jetbrains_cli');
    });

    test('packageDescription is defined', () {
      expect(packageDescription, isNotEmpty);
    });

    test('workflowName is defined', () {
      expect(workflowName, '@bchatard-alfred-jetbrains-next');
    });

    test('icon paths are defined', () {
      expect(iconNote, contains('AlertNoteIcon.icns'));
      expect(iconError, contains('AlertStopIcon.icns'));
      expect(iconDebug, contains('ProblemReport.icns'));
      expect(iconClock, contains('Clock.icns'));
      expect(iconNuclear, contains('BurningIcon.icns'));
      expect(iconBod, contains('public.generic-pc.icns'));
    });
  });
}
