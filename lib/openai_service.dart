import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:candy_ai/secret.dart';

class OpenAIService {
  int _requestCount = 0;
  final int _requestLimit = 5; // Limit to 5 requests
  final Duration _timeFrame = Duration(minutes: 1); // per minute
  Timer? _debounce;

  OpenAIService() {
    Timer.periodic(_timeFrame, (timer) {
      _requestCount = 0; // Reset the count after each time frame
    });
  }

  Future<String> isArtPromptAPI(String prompt) async {
    if (_requestCount >= _requestLimit) {
      return 'Rate limit exceeded. Please try again later.';
    }

    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }
    _debounce = Timer(Duration(seconds: 2), () async {
      _requestCount++;
      try {
        final res = await http.post(
          Uri.parse('https://api.openai.com/v1/chat/completions'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $openAIAPIKey',
          },
          body: jsonEncode({
            "model": "gpt-3.5-turbo",
            "messages": [
              {
                "role": "user",
                "content":
                    'Does this message want to generate an AI Picture, image, art or anything similar? $prompt. Simply answer with yes or no.'
              }
            ]
          }),
        );

        if (res.statusCode == 200) {
          final data = jsonDecode(res.body);
          return data['choices'][0]['message']['content'].trim();
        } else if (res.statusCode == 429) {
          // Handling insufficient quota
          print("Insufficient quota: ${res.body}");
        } else {
          print("Error: ${res.body}");
        }
      } catch (e) {
        print("Error: $e");
      }
    });

    return 'Request is being processed.';
  }

  Future<String> chatGPTAPI(String prompt) async {
    return 'CHATGPT: ';
  }

  Future<String> dallEAPI(String prompt) async {
    return 'DALL-E: ';
  }
}
