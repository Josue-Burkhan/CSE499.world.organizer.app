## Deep Link Registration Instructions

To ensure your Flutter application can handle the redirect from the web authentication flow, you need to register the custom URL scheme (`myapp://auth/callback`) in both your Android and iOS projects.

### Android (AndroidManifest.xml)

1.  Open the `android/app/src/main/AndroidManifest.xml` file.
2.  Locate the `<activity>` tag that has `android:name=".MainActivity"`.
3.  Inside this `<activity>` tag, add the following `<intent-filter>`:

    ```xml
    <intent-filter>
        <action android:name="android.intent.action.VIEW"/>
        <category android:name="android.intent.category.DEFAULT"/>
        <category android:name="android.intent.category.BROWSABLE"/>
        <data android:scheme="myapp" android:host="auth"/>
    </intent-filter>
    ```

    **Explanation:**
    *   `<action android:name="android.intent.action.VIEW"/>`: Specifies that this activity can display data to the user.
    *   `<category android:name="android.intent.category.DEFAULT"/>`: Allows the activity to be the default handler for the specified data.
    *   `<category android:name="android.intent.category.BROWSABLE"/>`: Allows the activity to be launched by a web browser to display data. This is crucial for handling redirects from web-based authentication.
    *   `<data android:scheme="myapp" android:host="auth"/>`: Defines the custom URL scheme (`myapp`) and host (`auth`) that your app will respond to. So, any URL starting with `myapp://auth/...` will be handled by your app.

### iOS (Info.plist)

1.  Open the `ios/Runner/Info.plist` file.
2.  Add the following XML snippet just before the final `</dict>` tag:

    ```xml
    <key>CFBundleURLTypes</key>
    <array>
        <dict>
            <key>CFBundleTypeRole</key>
            <string>Editor</string>
            <key>CFBundleURLSchemes</key>
            <array>
                <string>myapp</string>
            </array>
        </dict>
    </array>
    ```

    **Explanation:**
    *   `CFBundleURLTypes`: This key defines the URL schemes your app can handle.
    *   `CFBundleTypeRole`: Describes the role of the app for this URL type (Editor, Viewer, None, or Shell). 'Editor' is a common choice.
    *   `CFBundleURLSchemes`: An array of strings, where each string is a custom URL scheme your app will respond to. In this case, `myapp` is the scheme.

After making these changes, you should run `flutter clean` and then `flutter run` to ensure the changes are picked up by the build system.

**Important:** Remember to run `flutter pub get` in your project's root directory to ensure the `flutter_web_auth_2` and `shared_preferences` packages are downloaded and linked correctly.