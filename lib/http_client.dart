import 'package:http/http.dart' as http;

class HttpClient extends http.BaseClient {
  factory HttpClient(String? token) {
    final http.Client client = http.Client();
    return HttpClient._createInstance(client, token);
  }
  HttpClient._createInstance(this._inner, this.token);

  final http.Client _inner;
  final String? token;
//dvs
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    return _inner.send(request);
  }
}
