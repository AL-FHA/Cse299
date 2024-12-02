import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'dart:convert';

import 'package:chitter_chatter/Features/status/model/status_model.dart';
import 'package:chitter_chatter/Features/status/view/status_view.dart';
import 'package:chitter_chatter/Features/status/controller/status_controller.dart';

@GenerateMocks([StatusController])
import 'status_view_test.mocks.dart';

void main() {
  late MockStatusController mockStatusController;

  final mockStatuses = [
    StatusModel(
      name: 'Alice',
      status: 'Hello World!',
      date: DateTime.now(),
      profilePicture: 'base',
    ),
    StatusModel(
      name: 'Bob',
      status: 'Having a great day!',
      date: DateTime.now().subtract(Duration(hours: 1)),
      profilePicture: base64Encode([1, 2, 3]),
    ),
  ];

  setUp(() {
    mockStatusController = MockStatusController();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: StatusTab(),
    );
  }

  group('StatusTab Widget Tests', () {
    testWidgets('displays a loading indicator when statuses are being fetched',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
