// lib/core/config/api_config.dart

class ApiConfig {
  // Update this IP address when your wifi IP changes
  static const String ipAddress = '10.130.124.185';
  
  // Ports
  static const String httpsPort = '7241';
  static const String httpPort = '5116';
  
  // Base URLs
  static const String baseUrl = 'https://$ipAddress:$httpsPort/api';
  static const String rawBaseUrl = 'https://$ipAddress:$httpsPort';
}
