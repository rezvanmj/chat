import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:chat_project/presentation/core/const_routes.dart';
import 'package:chat_project/presentation/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/dio_init.dart';
import 'core/service_locator.dart';

String? token = '';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  _notificationConfig();

  try {
    // setting up service locator
    setUpGetIt();
    // initing dio (after setting locator)
    await initDio();
  } catch (e) {
    print('OMG${e}');
  }
  runApp(const MyApp());
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // NotificationController.requestUserPermissions(
    //   context,
    //   channelKey: 'basic_channel',
    //   permissionList: [],
    // );
    return MaterialApp(
        title: 'Chat room',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        navigatorKey: navigatorKey,
        onGenerateRoute: generateRoute,
        home: const InitPage());
  }
}

class InitPage extends StatefulWidget {
  const InitPage({Key? key}) : super(key: key);

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // logo

          // sign in button
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
                'signInTitle',
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
