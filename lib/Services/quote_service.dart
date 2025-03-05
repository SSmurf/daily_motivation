// services/quote_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'dart:io';
import '../models/quote.dart';

class QuoteService {
  final String baseUrl = 'https://api.quotable.io';
  late final http.Client _client;

  QuoteService() {
    // Create a client that accepts all certificates
    final HttpClient httpClient =
        HttpClient()..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    _client = IOClient(httpClient);
  }

  Future<Quote> getRandomQuote({String? category}) async {
    try {
      final url = category != null ? '$baseUrl/random?tags=$category' : '$baseUrl/random';

      final response = await _client.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Quote.fromJson(data);
      } else {
        throw Exception('Failed to load quote: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching quote: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}
