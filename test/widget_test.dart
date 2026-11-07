import 'package:flutter_test/flutter_test.dart';
import 'package:smartpark_flutter/app.dart';

void main() {
  testWidgets('SmartPark app can be created', (tester) async {
    await tester.pumpWidget(const SmartParkApp());
    expect(find.text('SmartPark'), findsWidgets);
  });
}
