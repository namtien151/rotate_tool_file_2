import 'package:flutter_test/flutter_test.dart';
import 'package:roate_text_tool2/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('RotateToolViewModel Tests -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}
