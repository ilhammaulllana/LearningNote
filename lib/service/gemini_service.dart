import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String apiKey = 'AIzaSyCTRblapF0x7rxn3Wzw6cnuhnRDtN78xyM';

  static Future<String> generateQuiz(String note) async {
    final url =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {
                "text":
                    "Buatkan 3 quiz pilihan ganda berdasarkan catatan berikut:\n$note",
              },
            ],
          },
        ],
      }),
    );

    final data = jsonDecode(response.body);

    return data['candidates'][0]['content']['parts'][0]['text'];
  }
}
