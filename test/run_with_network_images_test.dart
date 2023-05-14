import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:run_with_network_images/src/run_with_network_images.dart';

void main() {
  testWidgets('Network image is rendered in widget test', (
    WidgetTester tester,
  ) async {
    await runWithNetworkImages(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: Image.network(
            'https://dev-yakuza.posstree.com/assets/images/yakuza.jpg',
          ),
        ),
      );

      final image = tester.widget<Image>(find.byType(Image));
      expect(
        (image.image as NetworkImage).url,
        'https://dev-yakuza.posstree.com/assets/images/yakuza.jpg',
      );
    });
  });
}
