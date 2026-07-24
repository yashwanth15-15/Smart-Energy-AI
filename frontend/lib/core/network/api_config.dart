class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://smart-energy-ai-ivwu.onrender.com',
  );
}
