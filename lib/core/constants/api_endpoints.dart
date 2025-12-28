class ApiEndpoints {
  // Base URL - Change this to your computer's IP address
  static const String baseUrl = 'http://192.168.1.65:3000';
  
  // Auth Endpoints
  static const String login = '/auth/login';
  static const String refresh = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String me = '/auth/me';
}