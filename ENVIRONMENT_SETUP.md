# Environment Variables Setup Guide

This guide explains how to configure environment variables for your Flutter app to work with both local development and CI/CD builds.

## Overview

The app uses environment variables to securely manage API keys and configuration settings. This approach ensures:
- API keys are never committed to the repository
- Different configurations for different environments (debug, beta, production)
- Secure handling in CI/CD pipelines

## Local Development Setup

### 1. Create a Local .env File

Copy the example file and fill in your values:

```bash
cp .env.example .env
```

Edit `.env` with your actual values:

```env
# API Configuration
API_KEY=your-actual-api-key-here
BASE_URL=https://your-api-endpoint.com

# Flutter Environment
FLUTTER_ENV=debug
```

### 2. Install Dependencies

Make sure you have the required dependency:

```bash
flutter pub get
```

### 3. Run the App

The app will automatically read from your `.env` file:

```bash
flutter run
```

## CI/CD Setup (GitHub Actions)

### 1. Add Secrets to GitHub Repository

Go to your GitHub repository → Settings → Secrets and variables → Actions

Add the following repository secrets:

- `API_KEY`: Your production API key
- `BASE_URL`: Your production API base URL (optional, defaults to current URL)

### 2. How It Works in Workflows

The GitHub Actions workflows automatically:
1. Read secrets from GitHub repository settings
2. Inject them as environment variables during the build process
3. Flutter app reads these variables using `Platform.environment`

### 3. Environment Mapping

The build type determines the Flutter environment:

| Branch Pattern | Build Type | FLUTTER_ENV |
|---------------|------------|-------------|
| `main`, `master`, `release/*` | `release` | `production` |
| `beta/*`, `staging` | `beta` | `beta` |
| `develop`, `debug`, others | `debug` | `debug` |

## Code Usage

### Environment Class

The `Environment` class provides easy access to configuration:

```dart
import 'package:your_app/config/environment.dart';

// Get API key
String apiKey = Environment.apiKey;

// Get base URL
String baseUrl = Environment.baseUrl;

// Check environment
bool isProduction = Environment.isProduction;
bool isDebug = Environment.isDebug;

// Get environment info (for debugging)
Map<String, String> envInfo = Environment.environmentInfo;
```

### API Service Usage

The `ApiService` automatically uses environment variables:

```dart
import 'package:your_app/utils/api/api_services.dart';

ApiService apiService = ApiService();
// Automatically uses Environment.baseUrl and Environment.apiKey
```

## Environment Variables Reference

### Required Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `API_KEY` | Your API authentication key | `abc123xyz789` |

### Optional Variables

| Variable | Description | Default | Example |
|----------|-------------|---------|---------|
| `BASE_URL` | API base URL | `https://jsonplaceholder.typicode.com` | `https://api.yourapp.com` |
| `FLUTTER_ENV` | Environment mode | `debug` | `production`, `beta`, `debug` |

## Security Best Practices

### ✅ Do:
- Use GitHub Secrets for sensitive data in CI/CD
- Keep `.env` files local and never commit them
- Use different API keys for different environments
- Validate environment variables in production

### ❌ Don't:
- Commit `.env` files to version control
- Use production API keys in development
- Hardcode sensitive values in source code
- Share API keys in plain text

## Troubleshooting

### Local Development Issues

**Problem**: App can't find environment variables
**Solution**: 
1. Ensure `.env` file exists in project root
2. Check `.env` file format (no spaces around `=`)
3. Restart your development server

**Problem**: API calls failing
**Solution**:
1. Verify API key is correct in `.env`
2. Check BASE_URL format (include `https://`)
3. Test API key with a tool like Postman

### CI/CD Issues

**Problem**: Build fails with environment variable errors
**Solution**:
1. Verify secrets are set in GitHub repository settings
2. Check secret names match exactly (`API_KEY`, `BASE_URL`)
3. Ensure secrets have correct values

**Problem**: App builds but API calls fail
**Solution**:
1. Check if production API key is valid
2. Verify BASE_URL points to correct environment
3. Check API endpoint accessibility from CI/CD environment

## Example Configurations

### Development (.env)
```env
API_KEY=dev-key-12345
BASE_URL=https://api-dev.yourapp.com
FLUTTER_ENV=debug
```

### Production (GitHub Secrets)
```
API_KEY=prod-key-67890
BASE_URL=https://api.yourapp.com
```

## Testing Environment Setup

You can test your environment configuration:

```dart
void main() {
  print('Environment Info:');
  Environment.environmentInfo.forEach((key, value) {
    print('$key: $value');
  });
  
  // Validate environment
  bool isValid = Environment.validateEnvironment();
  print('Environment valid: $isValid');
}
```

## Support

If you encounter issues:
1. Check this documentation
2. Verify your `.env` file format
3. Ensure GitHub secrets are properly configured
4. Test with a simple API call to verify connectivity
