import 'dart:convert';
import 'package:daily_motivation/Utils/logger.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'dart:io';
import '../models/quote.dart';

class QuoteService {
  final String baseUrl = 'https://api.quotable.io';
  late final http.Client _client;

  QuoteService() {
    final HttpClient httpClient =
        HttpClient()..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    _client = IOClient(httpClient);
  }

  Future<Quote> getRandomQuote({String? category}) async {
    try {
      final url = category != null ? '$baseUrl/quotes/random?tags=$category' : '$baseUrl/quotes/random';

      AppLogger.api('Fetching quote from: $url');

      final response = await _client.get(Uri.parse(url));

      AppLogger.api('Response status: ${response.statusCode}');
      AppLogger.api('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        AppLogger.api('Quote fetched successfully');
        final quote = Quote.fromJson(data);
        AppLogger.debug('Quote data: $quote');
        return quote;
      } else {
        AppLogger.error('Failed to load quote: ${response.statusCode}');
        throw Exception('Failed to load quote: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.error('Error fetching quote: $e');
      throw Exception('Error fetching quote: $e');
    }
  }

  Future<List<Quote>> getRandomQuotes({int limit = 3}) async {
    try {
      final url = '$baseUrl/quotes/random?limit=$limit';
      AppLogger.api('Fetching random quotes from: $url');
      final response = await _client.get(Uri.parse(url));
      AppLogger.api('Response status: ${response.statusCode}');
      AppLogger.api('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          AppLogger.api('Fetched ${data.length} quotes.');
          return data.map<Quote>((json) => Quote.fromJson(json)).toList();
        } else {
          AppLogger.api('Fetched a single quote.');
          return [Quote.fromJson(data)];
        }
      } else {
        AppLogger.error('Failed to load quotes: ${response.statusCode}');
        throw Exception('Failed to load quotes: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.error('Error fetching quotes: $e');
      throw Exception('Error fetching quotes: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}
