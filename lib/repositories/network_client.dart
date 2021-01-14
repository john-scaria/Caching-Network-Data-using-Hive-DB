import 'package:http/http.dart' as http;

import 'package:meta/meta.dart';

class NetworkClient {
  final http.Client httpClient;
  //static const String lang = 'ml';
  //static const String countryIsoCode = 'IN';
  final String baseUrl = 'https://news.google.com/rss/search?q=';
  //final String day = '+when:2d';
  final String homeBaseUrl = 'https://news.google.com/news/rss';
  NetworkClient({@required this.httpClient});

  Future<String> fetchRssString(String _topic) async {
    final newsUrl = '$baseUrl$_topic';
    final newsResponse = await httpClient.get(newsUrl);
    if (newsResponse.statusCode != 200) {
      throw Exception('Error Fetching Data...');
    }
    return newsResponse.body;
  }

  /* Future<String> fetchRssStringWithLocale(
      String _topic, String _lang, String _countryIsoCode) async {
    final String conditionSetter =
        '&hl=$_lang-$_countryIsoCode&gl=$_countryIsoCode&ceid=$_countryIsoCode:$_lang';
    final newsUrl = '$baseUrl$_topic$day$conditionSetter';
    final newsResponse = await httpClient.get(newsUrl);
    if (newsResponse.statusCode != 200) {
      throw Exception('Error Fetching Data...');
    }
    return newsResponse.body;
  } */

  Future<String> fetchHomeRssString() async {
    final newsHomeUrl = '$homeBaseUrl';
    final newsHomeResponse = await httpClient.get(newsHomeUrl);
    if (newsHomeResponse.statusCode != 200) {
      throw Exception('Error Fetching Data...');
    }
    return newsHomeResponse.body;
  }

  /* Future<String> fetchHomeRssStringWithLocale(
      String _lang, String _countryIsoCode) async {
    final String homeConditionSetter =
        'hl=$_lang&gl=$_countryIsoCode&ceid=$_countryIsoCode:$_lang';
    final newsHomeUrl = '$homeBaseUrl$homeConditionSetter';
    final newsHomeResponse = await httpClient.get(newsHomeUrl);
    if (newsHomeResponse.statusCode != 200) {
      throw Exception('Error Fetching Data...');
    }
    return newsHomeResponse.body;
  } */
}
