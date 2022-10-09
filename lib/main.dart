import 'package:chat_project/presentation/core/const_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/dio_init.dart';
import 'core/service_locator.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  try {
    // setting up service locator
    setUpGetIt();
    // initing dio (after setting locator)
    await initDio();
  } catch (e) {
    print('OMGGGGGGGGGGGGGGGGGGG ${e}');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
              onPressed: () {
                Navigator.of(context).pushNamed(loginPage);
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
