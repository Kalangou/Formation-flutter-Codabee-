import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';

class Parser {
  Future<RssFeed> chargerRSS(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final feed = RssFeed.parse(response.body);
      return feed;
    } else {
      throw Exception('Failed to load RSS feed');
    }
  }
}
