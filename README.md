# Demo Jivo Flutter App

<img width="375" alt="image" src="https://github.com/JivoChat/JivoSDK-FlutterDemo/assets/47568606/d7a529b1-78e1-4206-ada7-29cb9940a89f">

Jivo SDK example on Flutter for Android and iOS.

[channelId] is your widget_id.

# How to configure

This is a more detailed instruction on how to setup Jivo.

## Add dependency

Add this dependency to your package's `pubspec.yaml` file.

```
dependencies:
  jivosdk_plugin: 0.9.2
```

## Platform: iOS

Add this lines at the top of the file `ios/Podfile`.

```
source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/JivoChat/cocoapods-repo.git'
```

Change to this lines in the file `ios/Podfile`.

```
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
  end
end
```

Update the file `ios/Runner/AppDelegate.swift`.

```
import UIKit
import Flutter
import JivoSDK
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        GeneratedPluginRegistrant.register(with: self)
        Jivo.notifications.handleLaunch(options: launchOptions)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Jivo.notifications.setPushToken(data: deviceToken)
    }

    override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        Jivo.notifications.setPushToken(data: nil)
    }

    override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let result = Jivo.notifications.didReceiveRemoteNotification(userInfo: userInfo) {
            completionHandler(result)
        }
        else {
            completionHandler(.noData)
        }
    }

    override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let preferableOptions: UNNotificationPresentationOptions
        if #available(iOS 14.0, *) {
            preferableOptions = [.banner, .sound, .badge] // Include .banner for iOS 14+
        } else {
            preferableOptions = [.sound, .badge] // Omit .banner for older iOS
        }

        if let options = Jivo.notifications.willPresent(notification: notification, preferableOptions: preferableOptions) {
            completionHandler(options)
        } else {
            completionHandler([])
        }
    }

    override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        Jivo.notifications.didReceive(response: response)
        completionHandler()
    }
}

```

## Platform: Android

Add this lines to `android/build.gradle`.


```
buildscript {
    ...
    repositories {
        google()
        mavenCentral()
        maven { url 'https://www.jitpack.io' }
    }
    dependencies {
        ...
        classpath 'com.google.gms:google-services:4.3.14'
    }
}

allprojects {
    repositories {
        ...
        google()
        mavenCentral()
        maven { url 'https://www.jitpack.io' }
    }
}
```

Add this lines to `android/app/build.gradle`.

```
plugins {
    ...
    id "dev.flutter.flutter-gradle-plugin"
    id 'com.google.gms.google-services'
}

android {
   ...
   buildFeatures {
       dataBinding = true
   }
   ...
}

dependencies {
    ...
    api platform('com.google.firebase:firebase-bom:32.7.2')
    api 'com.google.firebase:firebase-messaging'
}
```

Add Firebase Android configuration to `android/app/google-services.json`.

## Issues:

- ClassCastException: java.lang.String cannot be cast to java.util.List
https://github.com/JivoChat/JivoSDK-FlutterDemo/issues/7

- The operator does not see info in chat from setContactInfo method
https://github.com/JivoChat/JivoSDK-FlutterDemo/issues/8
