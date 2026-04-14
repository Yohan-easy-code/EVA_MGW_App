# Android Release Checklist

## Build Config

- Verify `applicationId` and `namespace` are correct: `com.yohanzouari.mgweva`
- Check `version` in `pubspec.yaml`
- Confirm release signing is configured with `android/key.properties`
- Keep `android/key.properties` and real keystore out of version control

## Signing

1. Copy `android/key.properties.example` to `android/key.properties`
2. Create or provide the upload keystore file referenced by `storeFile`
3. Fill:
   - `storePassword`
   - `keyPassword`
   - `keyAlias`
   - `storeFile`
4. Run a local release build and verify it is signed with the expected keystore

## App Identity

- App name: `MGW EVA`
- Launcher icon: adaptive icon configured in `android/app/src/main/res`
- Package path updated to `com.yohanzouari.mgweva`

## Release QA

- Launch app on a real Android device
- Verify dark theme rendering
- Verify offline startup with airplane mode enabled
- Verify BattlePlans editor opens and saves local data
- Verify Wiki search and filters
- Verify JSON export, import and reset flows
- Verify launcher icon and app label on home screen

## Build Commands

```bash
flutter build apk --release
flutter build appbundle --release
```

## Expected Outputs

- APK: `build/app/outputs/flutter-apk/app-release.apk`
- AAB: `build/app/outputs/bundle/release/app-release.aab`

## Store Readiness

- Prepare Play Store screenshots
- Prepare privacy policy if distribution requires it
- Verify `targetSdkVersion` from current Flutter toolchain is accepted by Play
- Verify signing key backup is stored securely
