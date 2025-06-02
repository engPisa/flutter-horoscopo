import 'dart:convert';
import 'package:http/http.dart' as http;

class HoroscopeService {
  static const _apiKey = '[INSERIR API KEY]';

  static Future<String> fetchHoroscope(String sign) async {
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$_apiKey',
    );
    
    final prompt = "Gere um horóscopo diário para o signo de $sign, escrito em português, com um tom inspirador e leve, usando no máximo 3 frases.";

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {
                "text": prompt
              }
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final horoscope = data['candidates'][0]['content']['parts'][0]['text'];
      return horoscope;
    } else {
      throw Exception('Erro ao buscar horóscopo com Gemini: ${response.body}');
    }
  }
}
