import 'package:flutter_test/flutter_test.dart';

import 'package:epiverse/main.dart';

void main() {
  testWidgets('App builds without crashing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const EpiverseApp());

    // Verify that the app builds without crashing.
    expect(find.byType(EpiverseApp), findsOneWidget);
  });
}
