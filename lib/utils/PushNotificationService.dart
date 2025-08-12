import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pristine_andaman_driver/DrawerPages/Home/offline_page.dart';
import 'package:pristine_andaman_driver/utils/ApiBaseHelper.dart';
import 'package:pristine_andaman_driver/utils/common.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constant.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
FirebaseMessaging messaging = FirebaseMessaging.instance;

Future<void> backgroundMessage(RemoteMessage message) async {}

class PushNotificationService {
  BuildContext context;
  ValueChanged onResult;

  PushNotificationService({required this.context, required this.onResult});

  Future initialise() async {
    await App.init();
    iOSPermission();

    messaging.getToken().then((token) async {
      fcmToken = token;
      onResult("yes");
    });

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        final payload = notificationResponse.payload ?? '';
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => OfflinePage(payload)),
          (route) => false,
        );
      },
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      App.localStorage.setBool("notStatus", true);
      notificationStatus = App.localStorage.getBool("notStatus")!;
      var data = message.notification!;
      var title = data.title.toString();
      var body = data.body.toString();
      var test = message.data;

      bookingId = "";
      if (test['Booking_id'] != null) {
        bookingId = test['Booking_id'];
      }

      if (title.contains("update")) {
        onResult("update");
      } else if (title.contains("cancelled")) {
        onResult("cancelled");
      } else {
        onResult(bookingId.toString());
      }

      var image = message.data['image'] ?? '';
      var type = message.data['type'] ?? '';
      var id = message.data['type_id'] ?? '';

      if (image != null && image != 'null' && image != '') {
        generateImageNotication(title, body, image, type, bookingId);
      } else {
        generateSimpleNotication(
          title,
          body,
          type,
          bookingId.toString() != "null" && bookingId != "" ? bookingId : "123",
        );
      }
    });

    messaging.getInitialMessage().then((RemoteMessage? message) async {
      await Future.delayed(Duration.zero);
    });

    FirebaseMessaging.onBackgroundMessage(backgroundMessage);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var test = message.data;
      bookingId = test['Booking_id'];
      if (test['booking_type'] == 'current') {
        onResult(bookingId);
      }
    });
  }

  void iOSPermission() async {
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }
}

Future<String> _downloadAndSaveImage(String url, String fileName) async {
  var directory = await getApplicationDocumentsDirectory();
  var filePath = '${directory.path}/$fileName';
  var response = await http.get(Uri.parse(url));

  var file = File(filePath);
  await file.writeAsBytes(response.bodyBytes);
  return filePath;
}

Future<void> generateImageNotication(
    String title, String msg, String image, String type, String id) async {
  var largeIconPath = await _downloadAndSaveImage(image, 'largeIcon');
  var bigPicturePath = await _downloadAndSaveImage(image, 'bigPicture');

  var bigPictureStyleInformation = BigPictureStyleInformation(
    FilePathAndroidBitmap(bigPicturePath),
    hideExpandedLargeIcon: true,
    contentTitle: title,
    htmlFormatContentTitle: true,
    summaryText: msg,
    htmlFormatSummaryText: true,
  );

  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'high_importance_channel',
    'big text channel name',
    channelDescription: 'big text channel description',
    sound: RawResourceAndroidNotificationSound('test'),
    playSound: true,
    enableVibration: true,
    largeIcon: FilePathAndroidBitmap(largeIconPath),
    styleInformation: bigPictureStyleInformation,
  );

  var platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0,
    title,
    msg,
    platformChannelSpecifics,
    payload: id,
  );
}

Future<void> generateSimpleNotication(
    String title, String msg, String type, String id) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'default_notification_channel',
    'High Importance Notifications',
    channelDescription: 'your channel description',
    importance: Importance.max,
    priority: Priority.max,
    playSound: true,
    enableVibration: true,
    enableLights: true,
    color: const Color.fromARGB(255, 255, 0, 0),
    ledColor: const Color.fromARGB(255, 255, 0, 0),
    ledOnMs: 1000,
    ledOffMs: 500,
    styleInformation: BigTextStyleInformation(""),
    sound: RawResourceAndroidNotificationSound('test'),
    ticker: 'ticker',
  );

  var iosDetail = DarwinNotificationDetails();

  var platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iosDetail,
  );

  await flutterLocalNotificationsPlugin.show(
    0,
    title,
    msg,
    platformChannelSpecifics,
    payload: id,
  );
}

ApiBaseHelper apiBaseHelper = new ApiBaseHelper();
registerToken() async {
  Map data = {
    "user_id": curUserId,
    "device_id": fcmToken,
  };
  Map response = await apiBaseHelper.postAPICall(
      Uri.parse(baseUrl + "update_Fcm_token_driver"), data);
  if (response['status']) {
    // token updated
  } else {
    // handle error
  }
}
