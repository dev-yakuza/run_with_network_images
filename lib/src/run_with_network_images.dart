import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'run_with_network_images.mocks.dart';

@GenerateMocks([
  HttpClient,
  HttpClientRequest,
  HttpClientResponse,
  HttpHeaders,
  StreamSubscription,
])
R runWithNetworkImages<R>(R Function() body) {
  return HttpOverrides.runZoned(
    body,
    createHttpClient: (_) => _createMockImageHttpClient(),
  );
}

MockHttpClient _createMockImageHttpClient() {
  final MockHttpClient client = MockHttpClient();
  final MockHttpClientRequest request = MockHttpClientRequest();
  final MockHttpClientRequest svgRequest = MockHttpClientRequest();

  when(client.getUrl(any)).thenAnswer((Invocation invocation) {
    return Future<HttpClientRequest>.value(
      invocation.positionalArguments[0].path.endsWith(".svg")
          ? svgRequest
          : request,
    );
  });

  _mockRequestResponse(request: request, image: _image);
  _mockRequestResponse(request: svgRequest, image: _svgImage);

  request.close();
  svgRequest.close();

  return client;
}

void _mockRequestResponse({
  required MockHttpClientRequest request,
  required List<int> image,
}) {
  final MockHttpClientResponse response = MockHttpClientResponse();
  final MockHttpHeaders headers = MockHttpHeaders();
  when(request.headers).thenReturn(headers);
  when(request.close()).thenAnswer(
    (_) => Future<HttpClientResponse>.value(response),
  );
  when(response.compressionState).thenReturn(
    HttpClientResponseCompressionState.notCompressed,
  );
  when(response.contentLength).thenReturn(image.length);
  when(response.statusCode).thenReturn(HttpStatus.ok);
  when(response.listen(
    any,
    onError: anyNamed("onError"),
    onDone: anyNamed("onDone"),
    cancelOnError: anyNamed("cancelOnError"),
  )).thenAnswer((Invocation invocation) {
    final void Function(List<int>) onData = invocation.positionalArguments[0];
    final onDone = invocation.namedArguments[#onDone];
    final onError = invocation.namedArguments[#onError];
    final bool? cancelOnError = invocation.namedArguments[#cancelOnError];

    return Stream<List<int>>.fromIterable(<List<int>>[image]).listen(
      onData,
      onDone: onDone,
      onError: onError,
      cancelOnError: cancelOnError,
    );
  });
}

final _image = base64Decode(
  "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==",
);

final _svgImage = base64Decode(
  "PHN2ZyBoZWlnaHQ9IjEiIHdpZHRoPSIxIj48L3N2Zz4=",
);
