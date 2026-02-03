import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:my_food/services/api_service.dart';

class MockHttpClient extends http.BaseClient {
  bool isClosed = false;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    throw UnimplementedError();
  }

  @override
  void close() {
    isClosed = true;
  }
}

void main() {
  test('ApiService dispose closes the client', () {
    final mockClient = MockHttpClient();
    final apiService = ApiService(client: mockClient);

    apiService.dispose();

    expect(mockClient.isClosed, isTrue);
  });
}
