import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/ai_service.dart';

final aiServiceProvider = Provider<AIService>((ref) {
  // TODO: Replace with actual API key from secure storage
  const apiKey = 'YOUR_GEMINI_API_KEY';
  return AIService(apiKey: apiKey);
});

final aiSummaryProvider = FutureProvider.family<String, String>((ref, content) async {
  final aiService = ref.watch(aiServiceProvider);
  final summary = await aiService.generateSummary(content);
  return summary ?? 'Unable to generate summary';
});

final aiTagsProvider = FutureProvider.family<List<String>?, String>((ref, content) async {
  final aiService = ref.watch(aiServiceProvider);
  return await aiService.suggestTags(content);
});

final aiInsightProvider = FutureProvider.family<String, String>((ref, content) async {
  final aiService = ref.watch(aiServiceProvider);
  final insight = await aiService.generateInsight(content);
  return insight ?? 'Unable to generate insight';
});

final aiMoodProvider = FutureProvider.family<String, String>((ref, content) async {
  final aiService = ref.watch(aiServiceProvider);
  final mood = await aiService.analyzeMood(content);
  return mood ?? 'Unable to analyze mood';
});
