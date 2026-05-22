import 'package:http/http.dart' as http;

import '../core/failure.dart';
import '../core/result.dart';

/// The public Vogue Fitness UAE WOD page.
const wodUrl = 'https://vfuae.com/wod/';

/// Fetches the raw `/wod/` HTML over HTTPS.
class WodRemoteSource {
  /// Creates a [WodRemoteSource], optionally with an injected [http.Client].
  WodRemoteSource({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  /// GETs [wodUrl] and returns its body, or a [NetworkFailure] on any error.
  Future<Result<String>> fetchHtml() async {
    try {
      final res = await _client
          .get(
            Uri.parse(wodUrl),
            headers: const {'User-Agent': 'VogueWOD/1.0'},
          )
          .timeout(const Duration(seconds: 20));
      if (res.statusCode != 200) {
        return Err(AppFailure.network(detail: 'HTTP ${res.statusCode}'));
      }
      return Ok(res.body);
    } on Object catch (e) {
      return Err(AppFailure.network(detail: '$e'));
    }
  }
}
