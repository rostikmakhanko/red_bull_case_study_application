# red_bull_case_study_application
# User Login and Content Page
 
A Flutter app for user login with email and password validation, browsing photo and video folders, powered by the [Pixabay API](https://pixabay.com/api/docs/).
 
## Features

- Email validation via regular expression
- Password validation by 4 criteria: at least 8 characters, a combination of lowercase,
uppercase, and a special character
- Browse media folders (Clouds, Cars, Urban, Mountains, Ocean, ...)
- Search folder contents
- Full-screen, pinch-to-zoom image viewer with metadata (resolution, duration, quality)
- Video detail sheet with metadata (resolution, duration, quality)

## Requirements
 
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (see `environment` in `pubspec.yaml` for the minimum version)
- Xcode (for iOS builds/simulator) — macOS only
- Android Studio (for Android builds/emulator)
- A free [Pixabay API key](https://pixabay.com/api/docs/#api_search_images) — sign up and copy your key from your account page
Run `flutter doctor` and resolve any issues before proceeding.
 
## API key — required
 
This app calls the Pixabay API directly from the client, so **every run and build command requires a `PIXABAY_API_KEY` to be provided via `--dart-define`.** There is no `.env` file or runtime config — the key is compiled in at build time.
 
If you omit the flag, `String.fromEnvironment('PIXABAY_API_KEY')` silently resolves to an empty string and all API requests will fail with an unauthorized error, rather than failing to build.
 
### Option A — pass the flag directly
 
```bash
flutter run --dart-define=PIXABAY_API_KEY=your_key_here
```
 
### Option B — use a config file (recommended for local dev)
 
Create a git-ignored file:
 
```json
// config/dev.json
{
  "PIXABAY_API_KEY": "your_key_here"
}
```
 
Then run:
 
```bash
flutter run --dart-define-from-file=config/dev.json
```
 
> `config/*.json` is git-ignored. A `config/dev.json.example` with a placeholder key is committed so the expected shape is documented — copy it and fill in your real key.
 
## Getting started
 
```bash
git clone <repo-url>
cd <repo-folder>
flutter pub get
```
 
## Running on the iOS Simulator
 
1. Open Simulator via Xcode, or list available devices:
```bash
   open -a Simulator
```
2. Confirm Flutter sees it:
```bash
   flutter devices
```
3. Run the app, providing the API key:
```bash
   flutter run -d "iPhone 15" --dart-define-from-file=config/dev.json
```
   (Replace `"iPhone 15"` with whichever simulator is booted — or omit `-d` if only one device/simulator is running.)
 
## Running on the Android Emulator
 
1. Open an emulator from Android Studio's Device Manager, or from the command line:
```bash
   emulator -list-avds
   emulator -avd <avd_name>
```
2. Confirm Flutter sees it:
```bash
   flutter devices
```
3. Run the app, providing the API key:
```bash
   flutter run -d emulator-5554 --dart-define-from-file=config/dev.json
```
   (Replace `emulator-5554` with your emulator's device id from `flutter devices`.)
 
## Building an Android APK
 
```bash
flutter build apk --release --dart-define-from-file=config/dev.json
```
 
The output APK is written to:
 
```
build/app/outputs/flutter-apk/app-release.apk
```
 
For a smaller, per-architecture split (recommended for distribution rather than testing):
 
```bash
flutter build apk --release --split-per-abi --dart-define-from-file=config/dev.json
```

## Project structure
 
```
lib/
  components/     # Reusable widgets (MediaListTile, VideoDetailSheet, MediaDetailViewer, ...)
  config/         # API key access
  models/         # Data models (PixabayMedia)
  screens/        # Top-level screens (LoginScreen, MediaLibraryScreen, ...)
  services/       # API clients (PixabayService)
  utils/          # Helper functions
```
 
## Known limitations

- Pixabay's API does not return a filename or upload date, so they are derived from tags/id and from URL paths respectively and may be absent or approximate.
- Pixabay's API does not support ordering by name, so the received photos and videos are sorted on client by the name built based on logic stated above.
- No caching for network requests yet.