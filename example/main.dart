import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:run_with_network_images/run_with_network_images.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Image.network(
        'https://dev-yakuza.posstree.com/assets/images/yakuza.jpg',
      ),
    );
  }
}

void main() {
  testWidgets('Network image is rendered in widget test', (
    WidgetTester tester,
  ) async {
    await runWithNetworkImages(() async {
      await tester.pumpWidget(const MyApp());

      final image = tester.widget<Image>(find.byType(Image));
      expect(
        (image.image as NetworkImage).url,
        'https://dev-yakuza.posstree.com/assets/images/yakuza.jpg',
      );
    });
  });
}
