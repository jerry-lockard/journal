import 'package:google_generative_ai/google_generative_ai.dart';

class AIService {
  final GenerativeModel _model;

  AIService({required String apiKey})
      : _model = GenerativeModel(
          model: 'gemini-pro',
          apiKey: apiKey,
        );

  Future<String> generateSummary(String content) async {
    try {
      final prompt = '''
Analyze the following journal entry and provide a brief, insightful summary that captures:
1. The main themes or topics
2. The emotional tone
3. Key insights or reflections

Journal Entry:
$content

Please provide a concise, well-written summary in a supportive and empathetic tone.
''';

      final response = await _model.generateContent([Content.text(prompt)]);
      return response.text ?? 'Unable to generate summary';
    } catch (e) {
      return 'Unable to generate summary: $e';
    }
  }

  Future<List<String>> suggestTags(String content) async {
    try {
      final prompt = '''
Based on the following journal entry, suggest 3-5 relevant tags or themes that capture the main topics, emotions, or contexts discussed.
Each tag should be a single word or short phrase.

Journal Entry:
$content

Please provide the tags in a comma-separated format.
''';

      final response = await _model.generateContent([Content.text(prompt)]);
      final text = response.text ?? '';
      return text
          .split(',')
          .map((tag) => tag.trim())
          .where((tag) => tag.isNotEmpty)
          .toList();
    } catch (e) {
      return ['error'];
    }
  }

  Future<String> generateInsight(String content) async {
    try {
      final prompt = '''
Analyze this journal entry and provide one meaningful insight or reflection that could be valuable for personal growth.
Keep the insight concise but impactful.

Journal Entry:
$content

Please provide a single, well-articulated insight.
''';

      final response = await _model.generateContent([Content.text(prompt)]);
      return response.text ?? 'Unable to generate insight';
    } catch (e) {
      return 'Unable to generate insight: $e';
    }
  }

  Future<String> analyzeMood(String content) async {
    try {
      final prompt = '''
Analyze the emotional tone of this journal entry and identify the primary mood or emotional state expressed.
Choose from: Happy, Calm, Reflective, Anxious, Sad, Excited, Grateful, or Neutral.

Journal Entry:
$content

Please respond with just the single most appropriate mood word.
''';

      final response = await _model.generateContent([Content.text(prompt)]);
      return response.text ?? 'Neutral';
    } catch (e) {
      return 'Neutral';
    }
  }
}
