import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/main.dart';

void main() {
  testWidgets('Roadly app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const RoadlyApp());

    expect(find.text('Roadly'), findsWidgets);
  });
}