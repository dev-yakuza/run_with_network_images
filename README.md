# run_with_network_images

A helper for providing mocked response to `Image.network` in Flutter widget tests.

## Introduction

When you test the app that includes `Image.network`, you get the `400` response.

Because, `Image.network` uses the `HttpClient` of `dart:io`, and the `HttpClient` of `dart:io` always returns the `400`response in the Flutter widget test.

To fix this issue, you should override the `HttpClient` to return the mock image instead of the `400` response.

This package overrides it to return the mock image instead of you.

## Installing

You can install this package by executing the following command.

```bash
flutter pub add --dev run_with_network_images
```

Or, open the `pubspec.yaml` file and add the `run_with_network_images` package to dev_dependencies as follows.

```yaml
...
dev_dependencies:
  run_with_network_images: [version]
...
```

## Example

You can use the `runWithNetworkImages` function to fix the `400` response issue of the `Image.network`. A full test example could look like the following.

```dart
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
```

You can just wrap the test code with `await runWithNetworkImages(() async {});` to fix the issue.

## Contributing

If you want to contribute to this package, please see [CONTRIBUTING](CONTRIBUTING.md).
