class ChatMessage {
  final String role; // 'user' or 'ai'
  final String content;

  ChatMessage({required this.role, required this.content});

  Map<String, dynamic> toJson() => {
    'role': role,
    'content': content,
  };

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      role: json['role'] ?? 'ai',
      content: json['content'] ?? '',
    );
  }
}

class ChatResponse {
  final String response;
  final List<String> suggestedActions;

  ChatResponse({required this.response, required this.suggestedActions});

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      response: json['response'] ?? '',
      suggestedActions: List<String>.from(json['suggested_actions'] ?? []),
    );
  }
}
