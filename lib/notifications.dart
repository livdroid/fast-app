import 'dart:io';

import 'package:fastapp/main.dart';
import 'package:fastapp/util/colors.dart';
import 'package:fastapp/views/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

class AppNotification {
  static schedule(Duration duration, DateTime endTime) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('Fastappp', 'Fastapp', 'On going notification for fasting',
            importance: Importance.max,
            priority: Priority.high,
            //timeoutAfter: , //Use this later
            ongoing: true,
            autoCancel: false,
            color: AppColors.green_dark,
            icon: 'app_icon',
            showProgress: true);
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    String formattedDate = DateFormat('HH:mm').format(endTime);
    await flutterLocalNotificationsPlugin.show(0, 'FastPal', 'Jeûne jusque ' + formattedDate, platformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(0, 'FastPal', 'Jeûne terminé !', tz.TZDateTime.now(tz.local).add(duration),
        const NotificationDetails(android: AndroidNotificationDetails('dimsun/fastapp', 'dimsun/fastapp', 'Success notification')),
        androidAllowWhileIdle: true, uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
  }

  static clearPendingNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  static stop() {
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
  }

  init(BuildContext context, NotificationAppLaunchDetails notificationAppLaunchDetails) {
    bool didNotificationLaunchApp = notificationAppLaunchDetails.didNotificationLaunchApp ?? false;

    _requestPermissions(didNotificationLaunchApp);
    //_configureDidReceiveLocalNotificationSubject(context);
    _configureSelectNotificationSubject(context);
  }

  void _requestPermissions(bool didNotificationLaunchApp) {
    if (!didNotificationLaunchApp) {
      return;
    }

    if (Platform.isAndroid) {
      return;
    }

    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>().requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void _configureDidReceiveLocalNotificationSubject(BuildContext context) {
    didReceiveLocalNotificationSubject.stream.listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null ? Text(receivedNotification.title) : null,
          content: receivedNotification.body != null ? Text(receivedNotification.body) : null,
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject(BuildContext context) {
    selectNotificationSubject.stream.listen((String payload) async {
      await Navigator.pushNamed(context, HomePage.ID);
    });
  }
}
