# Flutter Mobile App Build Workflow

This repository includes an automated GitHub Actions workflow that builds Android APK/AAB and iOS IPA files on every commit. The workflow is configurable through a JSON file, allowing you to enable or disable builds for specific platforms.

## 🚀 Features

- **Automated Builds**: Builds triggered on every push to `main` and `develop` branches
- **Configurable Platforms**: Enable/disable Android and iOS builds independently
- **Multiple Android Formats**: Generates both APK and AAB files
- **iOS Support**: Creates IPA files for iOS distribution
- **Artifact Storage**: Built files are stored as GitHub artifacts for 30 days
- **Test Integration**: Runs Flutter tests before building
- **Build Summary**: Provides detailed build status in GitHub Actions summary

## 📁 File Structure

```
.github/
└── workflows/
    └── build-mobile-apps.yml     # Main workflow file
build-config.json                 # Build configuration
ios/
└── Runner/
    └── ExportOptions.plist       # iOS export configuration
```

## ⚙️ Configuration

### Build Configuration File (`build-config.json`)

The workflow behavior is controlled by the `build-config.json` file in your repository root:

```json
{
  "android": {
    "enabled": true,
    "buildType": "release",
    "outputFormat": ["apk", "aab"]
  },
  "ios": {
    "enabled": true,
    "buildType": "release",
    "codesign": false
  },
  "flutter": {
    "version": "3.24.3",
    "channel": "stable"
  },
  "testing": {
    "runTests": true,
    "testTimeout": "10m"
  }
}
```

#### Configuration Options:

- **android.enabled**: `true/false` - Enable Android builds
- **ios.enabled**: `true/false` - Enable iOS builds
- **buildType**: `release/debug` - Build configuration
- **outputFormat**: Array of formats for Android (`["apk", "aab"]`)
- **codesign**: `true/false` - Enable iOS code signing (requires certificates)
- **flutter.version**: Flutter SDK version to use
- **flutter.channel**: Flutter channel (`stable`, `beta`, `dev`)
- **testing.runTests**: `true/false` - Run tests before building

## 🛠️ Setup Instructions

### 1. Repository Setup

1. **Fork or clone** this repository
2. **Ensure** your Flutter project is in the repository root
3. **Verify** that `pubspec.yaml` exists in the root directory

### 2. Configure Build Settings

1. **Edit** `build-config.json` to match your requirements:
   ```bash
   # Enable only Android builds
   {
     "android": { "enabled": true },
     "ios": { "enabled": false }
   }
   
   # Enable only iOS builds
   {
     "android": { "enabled": false },
     "ios": { "enabled": true }
   }
   
   # Enable both platforms
   {
     "android": { "enabled": true },
     "ios": { "enabled": true }
   }
   ```

### 3. Android Setup

#### Prerequisites:
- Your Flutter project should have proper Android configuration
- `android/app/build.gradle.kts` should be properly configured
- No additional setup required for basic APK/AAB generation

#### Signing (Optional):
For signed APKs, add these secrets to your GitHub repository:

1. Go to **Settings** → **Secrets and variables** → **Actions**
2. Add the following secrets:
   - `ANDROID_KEYSTORE_BASE64`: Base64 encoded keystore file
   - `ANDROID_KEYSTORE_PASSWORD`: Keystore password
   - `ANDROID_KEY_ALIAS`: Key alias
   - `ANDROID_KEY_PASSWORD`: Key password

Then update the workflow to use these secrets for signing.

### 4. iOS Setup

#### Prerequisites:
- macOS development environment (handled by GitHub Actions)
- Proper iOS configuration in `ios/` directory
- Valid `ios/Runner.xcworkspace`

#### For Development Builds (No Signing):
- No additional setup required
- Uses the provided `ExportOptions.plist`

#### For Distribution Builds (With Signing):
1. **Add iOS certificates and provisioning profiles** to GitHub Secrets:
   - `IOS_CERTIFICATE_BASE64`: Base64 encoded .p12 certificate
   - `IOS_CERTIFICATE_PASSWORD`: Certificate password
   - `IOS_PROVISIONING_PROFILE_BASE64`: Base64 encoded provisioning profile

2. **Update** `ios/Runner/ExportOptions.plist`:
   ```xml
   <key>method</key>
   <string>app-store</string> <!-- or ad-hoc, enterprise -->
   <key>teamID</key>
   <string>YOUR_TEAM_ID</string>
   ```

3. **Enable codesigning** in `build-config.json`:
   ```json
   {
     "ios": {
       "enabled": true,
       "codesign": true
     }
   }
   ```

### 5. GitHub Actions Setup

1. **Push** your changes to the repository
2. **Navigate** to **Actions** tab in your GitHub repository
3. **Verify** that the workflow appears and runs successfully
4. **Check** the workflow status and download artifacts

## 📱 Platform-Specific Notes

### Android
- **APK**: Direct installation file for Android devices
- **AAB**: Android App Bundle for Google Play Store distribution
- **Build time**: ~5-10 minutes
- **Runner**: Ubuntu (faster, cost-effective)

### iOS
- **IPA**: iOS application archive for distribution
- **Build time**: ~10-20 minutes
- **Runner**: macOS (required for iOS builds)
- **Limitations**: Development builds only without proper certificates

## 🔄 Workflow Triggers

The workflow runs automatically on:
- **Push** to `main` branch
- **Push** to `develop` branch
- **Pull requests** to `main` branch

### Manual Trigger
You can also trigger builds manually:
1. Go to **Actions** tab
2. Select **Build Mobile Apps** workflow
3. Click **Run workflow**
4. Choose the branch and click **Run workflow**

## 📦 Downloads & Releases

The workflow provides built files in **two ways**:

### 🎯 GitHub Releases (Recommended)
Built files are automatically published to the **Releases page** with detailed information:

1. **Navigate** to your repository's **Releases** page
2. **Find** the latest release (named with version and build number)
3. **Download** the files directly:
   - `app-release.apk`: Android APK file
   - `app-release.aab`: Android App Bundle
   - `*.ipa`: iOS application file

**Release Features:**
- ✅ Automatic versioning from `pubspec.yaml`
- ✅ Detailed release notes with build info
- ✅ Build status and configuration details
- ✅ Direct download links
- ✅ Permanent storage (no expiration)

### 📁 GitHub Artifacts (Backup)
Built files are also available as GitHub artifacts:

1. **Navigate** to the completed workflow run
2. **Scroll down** to the "Artifacts" section
3. **Download**:
   - `android-apk`: Contains the APK file
   - `android-aab`: Contains the AAB file
   - `ios-app`: Contains the IPA file

Artifacts are retained for **30 days** by default.

## 🐛 Troubleshooting

### Common Issues:

#### 1. Android Build Fails
```bash
# Check these files exist and are properly configured:
- android/app/build.gradle.kts
- android/build.gradle.kts
- android/settings.gradle.kts
```

#### 2. iOS Build Fails
```bash
# Verify iOS configuration:
- ios/Runner.xcworkspace exists
- ios/Runner/Info.plist is properly configured
- ExportOptions.plist has correct settings
```

#### 3. Flutter Version Issues
```bash
# Update Flutter version in build-config.json:
{
  "flutter": {
    "version": "3.24.3",  # Use your project's Flutter version
    "channel": "stable"
  }
}
```

#### 4. Test Failures
```bash
# Disable tests temporarily:
{
  "testing": {
    "runTests": false
  }
}
```

### Debug Steps:

1. **Check workflow logs** in GitHub Actions
2. **Verify** `build-config.json` syntax (use JSON validator)
3. **Test locally** with `flutter build apk` and `flutter build ios`
4. **Check** Flutter and Dart versions compatibility

## 🔧 Customization

### Adding Custom Build Steps

Edit `.github/workflows/build-mobile-apps.yml` to add custom steps:

```yaml
- name: Custom Pre-build Step
  run: |
    echo "Running custom commands..."
    # Add your custom commands here

- name: Build APK
  run: flutter build apk --release
```

### Changing Artifact Retention

```yaml
- name: Upload APK artifact
  uses: actions/upload-artifact@v4
  with:
    name: android-apk
    path: build/app/outputs/flutter-apk/app-release.apk
    retention-days: 90  # Change from 30 to 90 days
```

### Adding Notifications

Add notification steps to inform about build status:

```yaml
- name: Notify on Success
  if: success()
  run: |
    echo "Build completed successfully!"
    # Add webhook or email notification here
```

## 📋 Checklist for Setup

- [ ] Repository contains Flutter project in root
- [ ] `build-config.json` is configured correctly
- [ ] `ios/Runner/ExportOptions.plist` exists
- [ ] Workflow file is in `.github/workflows/`
- [ ] Repository secrets are configured (if using signing)
- [ ] First workflow run completed successfully
- [ ] Artifacts are downloadable

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test the workflow
5. Submit a pull request

## 📄 License

This workflow configuration is provided as-is. Modify according to your project needs.

---

**Need help?** Check the GitHub Actions logs or create an issue in the repository.
