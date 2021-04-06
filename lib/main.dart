import 'package:fastapp/bloc/home_bloc.dart';
import 'package:fastapp/notifications.dart';
import 'package:fastapp/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
///
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject = BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject = BehaviorSubject<String>();

const MethodChannel platform = MethodChannel('dimsun.xyz/fastapp');

class ReceivedNotification {
  ReceivedNotification({
    this.id,
    this.title,
    this.body,
    this.payload,
  });

  final int id;
  final String title;
  final String body;
  final String payload;
}

String selectedNotificationPayload;

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String timeZoneName = await platform.invokeMethod<String>('getTimeZoneName');
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _configureLocalTimeZone();
  final NotificationAppLaunchDetails notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  /*
  String initialRoute = HomePage.ID;
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    selectedNotificationPayload = notificationAppLaunchDetails.payload;
    initialRoute = HomePage.ID;
  }
   */

  String initialRoute = HomePage.ID;

  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');

  final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: (int id, String title, String body, String payload) async {
        didReceiveLocalNotificationSubject.add(ReceivedNotification(id: id, title: title, body: body, payload: payload));
      });

  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    selectedNotificationPayload = payload;
    selectNotificationSubject.add(payload);
  });

  runApp(MyApp(initialRoute, notificationAppLaunchDetails, selectedNotificationPayload));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  final NotificationAppLaunchDetails notificationAppLaunchDetails;
  final String selectedNotificationPayload;

  MyApp(this.initialRoute, this.notificationAppLaunchDetails, this.selectedNotificationPayload);

  @override
  Widget build(BuildContext context) {
    AppNotification().init(context, notificationAppLaunchDetails);

    return MaterialApp(
      title: 'FastPal',
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => HomeBloc(),
        child: HomePage(),
      ),
      initialRoute: HomePage.ID,
      routes: <String, WidgetBuilder>{
        HomePage.ID: (_) => HomePage(),
      },
    );
  }
}
