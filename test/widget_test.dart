// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:l10n_manipulator/blocs/project/editor_bloc.dart';
import 'package:l10n_manipulator/config/project_type.dart';

void main() {
  test('locale', () {
    var projectState = EditorState(
      path: '/Users/tungpt/Development/sales_cloud',
      projectType: ProjectType.flutter,
    );
  });
}
