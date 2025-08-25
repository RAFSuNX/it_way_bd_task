import 'dart:io';

class Environment {
  static const String _apiKeyKey = 'API_KEY';
  static const String _baseUrlKey = 'BASE_URL';
  
  // Default values for development
  static const String _defaultBaseUrl = 'https://jsonplaceholder.typicode.com';
  static const String _defaultApiKey = 'your-development-api-key';

  /// Get API key from environment variables
  /// Priority: Environment variable > Default value
  static String get apiKey {
    // First try to get from environment variables (works in CI/CD)
    String? envApiKey = Platform.environment[_apiKeyKey];
    if (envApiKey != null && envApiKey.isNotEmpty) {
      return envApiKey;
    }
    
    // Fallback to default for development
    return _defaultApiKey;
  }

  /// Get base URL from environment variables
  /// Priority: Environment variable > Default value
  static String get baseUrl {
    String? envBaseUrl = Platform.environment[_baseUrlKey];
    if (envBaseUrl != null && envBaseUrl.isNotEmpty) {
      return envBaseUrl;
    }
    
    return _defaultBaseUrl;
  }

  /// Check if we're running in production mode
  static bool get isProduction {
    return Platform.environment['FLUTTER_ENV'] == 'production';
  }

  /// Check if we're running in debug mode
  static bool get isDebug {
    return Platform.environment['FLUTTER_ENV'] == 'debug' || 
           Platform.environment['FLUTTER_ENV'] == null;
  }

  /// Get all environment info for debugging
  static Map<String, String> get environmentInfo {
    return {
      'API_KEY': apiKey.replaceRange(4, null, '*' * (apiKey.length - 4)), // Mask API key for security
      'BASE_URL': baseUrl,
      'FLUTTER_ENV': Platform.environment['FLUTTER_ENV'] ?? 'debug',
      'IS_PRODUCTION': isProduction.toString(),
      'IS_DEBUG': isDebug.toString(),
    };
  }

  /// Validate that all required environment variables are set
  static bool validateEnvironment() {
    if (isProduction && apiKey == _defaultApiKey) {
      print('WARNING: Using default API key in production environment!');
      return false;
    }
    return true;
  }
}
