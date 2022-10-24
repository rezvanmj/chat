import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:chat_project/presentation/core/const_routes.dart';
import 'package:chat_project/presentation/home/home_view.dart';
import 'package:chat_project/presentation/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

import 'background_service.dart';
import 'core/dio_init.dart';
import 'core/service_locator.dart';

String? token = '';

final StreamController<ReceivedNotification> didReceiveLocalNotificationStream =
    StreamController<ReceivedNotification>.broadcast();

final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final service = FlutterBackgroundService();

void main() async {
  NotificationController();
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  _notificationConfig();
  service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
  try {
    WidgetsFlutterBinding.ensureInitialized();
    setUpGetIt();
    await initDio();
  } catch (e) {
    print('OMG${e}');
  }
  runApp(const MyApp());

  // BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

void _notificationConfig() {
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });

  AwesomeNotifications().initialize(
      '',
      [
        NotificationChannel(
            enableLights: true,
            enableVibration: true,
            vibrationPattern: lowVibrationPattern,
            // defaultRingtoneType: DefaultRingtoneType,
            playSound: true,
            channelShowBadge: true,
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Colors.orange,
            ledColor: Colors.white)
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: false);

  AwesomeNotifications().setListeners(
    onActionReceivedMethod: (ReceivedAction receivedAction) {
      return NotificationController.onActionReceivedMethod(
          receivedAction, navigatorKey.currentContext!);
    },
    onNotificationCreatedMethod: (ReceivedNotification receivedNotification) {
      return NotificationController.onNotificationCreatedMethod(
          receivedNotification);
    },
    onNotificationDisplayedMethod: (ReceivedNotification receivedAction) {
      return NotificationController.onNotificationDisplayedMethod(
          receivedAction, navigatorKey.currentContext!);
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Chat room',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        navigatorKey: navigatorKey,
        onGenerateRoute: generateRoute,
        home: const HomeView());
  }
}

class InitPage extends StatefulWidget {
  const InitPage({Key? key}) : super(key: key);

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  // bool _enabled = true;
  // int _status = 0;
  // final List<DateTime> _events = [];

  @override
  void initState() {
    super.initState();
    // initPlatformState();
  }

  // Future<void> initPlatformState() async {
  //   // Configure BackgroundFetch.
  //   int status = await BackgroundFetch.configure(
  //       BackgroundFetchConfig(
  //           minimumFetchInterval: 15,
  //           stopOnTerminate: false,
  //           enableHeadless: true,
  //           requiresBatteryNotLow: false,
  //           requiresCharging: false,
  //           requiresStorageNotLow: false,
  //           requiresDeviceIdle: false,
  //           requiredNetworkType: NetworkType.ANY), (String taskId) async {
  //     // <-- Event handler
  //     // This is the fetch-event callback.
  //     print("[BackgroundFetch] Event received $taskId");
  //     setState(() {
  //       _events.insert(0, new DateTime.now());
  //     });
  //     // IMPORTANT:  You must signal completion of your task or the OS can punish your app
  //     // for taking too long in the background.
  //     BackgroundFetch.finish(taskId);
  //   }, (String taskId) async {
  //     // <-- Task timeout handler.
  //     // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
  //     print("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
  //     BackgroundFetch.finish(taskId);
  //   });
  //   print('[BackgroundFetch] configure success: $status');
  //   setState(() {
  //     _status = status;
  //   });
  //
  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) return;
  // }
  //
  // void _onClickEnable(enabled) {
  //   setState(() {
  //     _enabled = enabled;
  //   });
  //   if (enabled) {
  //     BackgroundFetch.start().then((int status) {
  //       print('[BackgroundFetch] start success: $status');
  //     }).catchError((e) {
  //       print('[BackgroundFetch] start FAILURE: $e');
  //     });
  //   } else {
  //     BackgroundFetch.stop().then((int status) {
  //       print('[BackgroundFetch] stop success: $status');
  //     });
  //   }
  // }
  //
  // void _onClickStatus() async {
  //   int status = await BackgroundFetch.status;
  //   print('[BackgroundFetch] status: $status');
  //   setState(() {
  //     _status = status;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: MaterialButton(
              // color: whiteColor,
              onPressed: () async {
                // Navigator.of(context)
                //     .pushNamedAndRemoveUntil(homePage, (route) => false);
                Navigator.of(context).pushNamed(loginPage);
                // final prefs = await SharedPreferences.getInstance();
                // token = ((prefs.get('token')) as String?)!;
                // log('TOOKKKKKEEEEENN ${token}');

                // if (token == null) {
                //   Navigator.of(context).pushNamed(loginPage);
                // } else {
                //   Navigator.of(context)
                //       .pushNamedAndRemoveUntil(homePage, (route) => false);
                // }
              },
              child: const Text(
                'signIn',
                style: TextStyle(
                  // color: primaryColor,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
