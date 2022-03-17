import 'dart:convert';

import 'package:sanity_test/app_exceptions.dart';
import 'package:sanity_test/http_client.dart';
import 'package:http/http.dart' as http;
import 'package:sanity_test/utils.dart';

class SanityClient {
  factory SanityClient({
    required String projectId,
    required String dataset,
    String? token,
    bool useCdn = true,
  }) {
    final HttpClient client = HttpClient(token);
    return SanityClient._createInstance(
      client,
      projectId: projectId,
      dataset: dataset,
      useCdn: useCdn,
    );
  }

  SanityClient._createInstance(
    this._client, {
    required this.projectId,
    required this.dataset,
    this.token,
    this.useCdn = true,
  });

  final HttpClient _client;
  final String projectId;
  final String dataset;
  final String? token;
  final bool useCdn;

  Uri _buildUri({required String query, Map<String, dynamic>? params}) {
    final Map<String, dynamic> queryParameters = <String, dynamic>{
      'query': query,
      if (params != null) ...params,
    };
    // https://52b2mvj6.api.sanity.io/v2021-10-21/data/query/production?query=%0A*%5B_type%20%3D%3D%20%27corporateAnnouncement%27%5D%0A%0A
    return Uri(
      scheme: 'https',
      host: '$projectId.api.sanity.io',
      path: '$version/data/query/$dataset',
      queryParameters: queryParameters,
    );
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        final Map<String, dynamic> responseJson = jsonDecode(response.body);
        return responseJson['result'];
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorizedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException('Error occured while communication with server with status code: ${response.statusCode}');
    }
  }

  Future<dynamic> fetch({required String query, Map<String, dynamic>? params}) async {
    final Uri uri = _buildUri(query: query, params: params);
    final http.Response response = await _client.get(uri);
    return _returnResponse(response);
  }
}
