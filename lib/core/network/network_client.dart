import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkClient {
  final http.Client client;

  NetworkClient({required this.client});

  Future<dynamic> get(String url) async {
    try {
      final response = await client.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }
}
