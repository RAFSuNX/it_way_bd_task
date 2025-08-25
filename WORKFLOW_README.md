# Super Simple Flutter App Builder Guide

**Think of this like a magic robot that builds your app every time you save your code!**

## What Does This Do? (For 5-Year-Olds)

Imagine you have a toy box (your code) and every time you put a new toy in it, a magic robot:
1. Makes an Android app (like for Samsung phones)
2. Makes an iPhone app (like for iPhones)
3. Puts them in a special box where everyone can download them

**That's exactly what this does with your Flutter app!**

---

## Quick Start (3 Easy Steps)

### Step 1: Copy These Magic Files
Put these files in your project (like putting toys in the right boxes):

```
Your Project
├── .github/workflows/
│   ├── build-mobile-apps.yml
│   ├── android/
│   │   └── build-android.yml
│   └── ios/
│       └── build-ios.yml
├── build-config.json
└── ios/Runner/
    └── ExportOptions.plist
```

### Step 2: Save Your Code
```bash
git add .
git commit -m "Add magic app builder"
git push
```

### Step 3: Watch the Magic!
- Go to your GitHub page
- Click "Actions" tab
- Watch your apps being built automatically!

**That's it! You're done!**

---

## How It Works (Simple Version)

### Different Branches = Different Types of Apps

Think of branches like different colored boxes:

| Box Color (Branch) | What You Get | Example |
|-------------------|--------------|---------|
| 🟢 **main** | Perfect app for everyone | "MyApp v1.0 (release)" |
| 🟡 **develop** | Test app for trying things | "MyApp v1.0 (debug)" |
| 🟠 **beta** | Almost-ready app | "MyApp v1.0 (beta)" |

### What Happens When You Push Code:

1. **Robot reads your settings** (from `build-config.json`)
2. **Builds Android app** (APK + AAB files)
3. **Builds iPhone app** (IPA file)
4. **Creates a download page** (GitHub Release)
5. **Tells you it's done!**

---

## Settings File Explained (build-config.json)

This is like the robot's instruction manual. Here's what each part does:

### Basic Settings
```json
{
  "android": {
    "enabled": true,           // Build Android apps
    "outputFormat": ["apk", "aab"]  // Make both types
  },
  "ios": {
    "enabled": true,           // Build iPhone apps
    "codesign": false          // Don't sign (for testing)
  }
}
```

### Branch Rules (Which Branch = Which Build Type)
```json
{
  "branchMapping": {
    "main": "release",         // 🟢 main branch = release build
    "develop": "debug",        // 🟡 develop branch = debug build
    "beta": "beta",           // 🟠 beta branch = beta build
    "default": "debug"        // any other branch = debug build
  }
}
```

### Signing Rules (When to Make "Real" Apps)
```json
{
  "requireSigning": {
    "release": true,          // 🟢 Release needs signing keys
    "beta": false,           // 🟠 Beta doesn't need signing
    "debug": false           // 🟡 Debug doesn't need signing
  }
}
```

---

## Step-by-Step: Making Your First Build

### Super Beginner Steps:

1. **Put the files in your project**
   - Copy all the workflow files
   - Make sure they're in the right folders

2. **Save everything to GitHub**
   ```bash
   git add .
   git commit -m "Add app builder"
   git push
   ```

3. **Watch it work**
   - Go to GitHub.com
   - Open your project
   - Click "Actions" tab
   - See the magic happen!

4. **Download your apps**
   - Click "Releases" tab
   - Download APK (Android) or IPA (iPhone)
   - Install on your phone!

---

## Customizing Your Robot

### Want to Change Something?

**Edit `build-config.json` file:**

#### Turn Off iPhone Builds:
```json
{
  "ios": {
    "enabled": false
  }
}
```

#### Change Flutter Version:
```json
{
  "flutter": {
    "version": "3.35.1"
  }
}
```

#### Add New Branch Rule:
```json
{
  "branchMapping": {
    "feature/*": "debug",
    "hotfix/*": "beta"
  }
}
```

---

## Different Types of Builds

### 🟡 Debug Build (For Testing)
- **When**: Push to `develop` branch
- **What**: Test version with debug info
- **Files**: `TaskManager_1.0.0_debug_20250825.apk`, `TaskManager_1.0.0_debug_20250825.aab`
- **Signing**: Not needed

### 🟠 Beta Build (For Friends to Test)
- **When**: Push to `beta` branch
- **What**: Almost-ready version
- **Files**: `TaskManager_1.0.0_beta_20250825.apk`, `TaskManager_1.0.0_beta_20250825.aab`
- **Signing**: Not needed

### 🟢 Release Build (For Everyone)
- **When**: Push to `main` branch
- **What**: Perfect version for app stores
- **Files**: `TaskManager_1.0.0_release_20250825.apk`, `TaskManager_1.0.0_release_20250825.aab` (signed)
- **Signing**: Required!

---

## Setting Up Signing (For Release Builds)

**Only needed for release builds (main branch)**

### Android Signing:

1. **Create a keystore file** (ask a grown-up developer)
2. **Add these secrets to GitHub:**
   - Go to your GitHub project
   - Click Settings → Secrets → Actions
   - Add these secrets:

| Secret Name | What It Is |
|-------------|------------|
| `ANDROID_KEYSTORE_BASE64` | Your keystore file (encoded) |
| `ANDROID_KEYSTORE_PASSWORD` | Password for keystore |
| `ANDROID_KEY_ALIAS` | Key name |
| `ANDROID_KEY_PASSWORD` | Password for key |

### iPhone Signing:

1. **Get certificates from Apple** (ask a grown-up developer)
2. **Add these secrets to GitHub:**

| Secret Name | What It Is |
|-------------|------------|
| `IOS_CERTIFICATE_BASE64` | Your certificate file (encoded) |
| `IOS_CERTIFICATE_PASSWORD` | Password for certificate |
| `IOS_PROVISIONING_PROFILE_BASE64` | Your provisioning profile (encoded) |

---

## Where to Find Your Built Apps

### Method 1: Releases Page (Easy!)
1. Go to your GitHub project
2. Click "Releases" tab
3. Click on the latest release
4. Download the files you want!

### Method 2: Actions Page (For Nerds)
1. Go to your GitHub project
2. Click "Actions" tab
3. Click on a completed workflow
4. Scroll down to "Artifacts"
5. Download the zip files

---

## Troubleshooting (When Things Go Wrong)

### "Build Failed" - Don't Panic!

1. **Check the error message:**
   - Go to Actions tab
   - Click the failed build
   - Read the red error text

2. **Common fixes:**
   - **Flutter version wrong**: Update `flutter.version` in config
   - **Missing signing keys**: Add secrets for release builds
   - **Code has errors**: Fix your Flutter code first

### Still Stuck?

1. **Check your files are in the right places**
2. **Try pushing to `develop` branch first** (easier than `main`)
3. **Ask a grown-up developer for help**

---

## Success! What You Get

After everything works, you'll have:

### For Android:
- **APK file**: Install directly on Android phones
- **AAB file**: Upload to Google Play Store

### For iPhone:
- **IPA file**: Install on iPhones (needs special setup)

### Automatic Features:
- New release created automatically
- Files uploaded and ready to download
- Version numbers from your `pubspec.yaml`
- Build notes with all the details

---

## Quick Reference

### Branch → Build Type
- `main` → 🟢 Release (needs signing)
- `develop` → 🟡 Debug (no signing)
- `beta` → 🟠 Beta (no signing)

### File Locations
- Main settings: `build-config.json`
- Android workflow: `.github/workflows/android/build-android.yml`
- iPhone workflow: `.github/workflows/ios/build-ios.yml`
- Main workflow: `.github/workflows/build-mobile-apps.yml`

### Quick Changes
- Turn off iPhone: Set `ios.enabled` to `false`
- Change Flutter version: Update `flutter.version`
- Add new branch rule: Add to `branchMapping`

---

## That's It!

**You now have a magic robot that builds your apps automatically!**

Every time you save your code to GitHub, it will:
1. Look at which branch you used
2. Decide what type of build to make
3. Build your Android and iPhone apps
4. Put them in a nice download page
5. Tell you when it's done!

**Happy coding!**

---

*Made with love for developers who want their apps built automatically!*
