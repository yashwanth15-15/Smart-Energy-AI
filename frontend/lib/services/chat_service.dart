import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/models/chat_model.dart';
import 'package:frontend/core/network/api_config.dart';

final chatProvider = NotifierProvider<ChatNotifier, List<ChatMessage>>(() {
  return ChatNotifier();
});

class ChatNotifier extends Notifier<List<ChatMessage>> {
  @override
  List<ChatMessage> build() {
    return [
      ChatMessage(role: 'ai', content: 'Hello! I am your AI Campus Copilot. How can I assist you with energy management today?')
    ];
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  List<String> _suggestions = ['Analyze Building', 'Show Predictions'];
  List<String> get suggestions => _suggestions;

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    
    // Add user message
    state = [...state, ChatMessage(role: 'user', content: text)];
    _isLoading = true;
    _suggestions = [];
    
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/copilot/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'messages': state.map((m) => m.toJson()).toList(),
        }),
      );

      if (response.statusCode == 200) {
        final data = ChatResponse.fromJson(jsonDecode(response.body));
        state = [...state, ChatMessage(role: 'ai', content: data.response)];
        _suggestions = data.suggestedActions;
      } else {
        state = [...state, ChatMessage(role: 'ai', content: 'Error connecting to AI service. Please try again later.')];
      }
    } catch (e) {
      state = [...state, ChatMessage(role: 'ai', content: 'Network error. Please ensure you are connected to the server.')];
    } finally {
      _isLoading = false;
    }
  }
}
