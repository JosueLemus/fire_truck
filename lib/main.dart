import 'dart:async';

import 'package:bomberman/config/navigation/application_routes.dart';
import 'package:bomberman/firebase_options.dart';
import 'package:bomberman/presentation/screens/splash_screen.dart';
import 'package:bomberman/config/services/background_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final token = await FirebaseMessaging.instance.getToken();
  print(token);
  // await initializeService();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.red,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          elevation: 10.0,
        ),
      ),
      routes: getApplicationRoutes(),
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: ((context) => const SplashScreen()));
      },
    );
  }
}

// import 'dart:io';

// import 'package:bomberman/presentation/screens/google_map_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_fonts/google_fonts.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

//   @override
//   void initState() {
//     WidgetsBinding.instance.addObserver(this);
//     super.initState();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) async {
//     super.didChangeAppLifecycleState(state);
//     _onAppResumed(state);
//   }

//   void _onAppResumed(AppLifecycleState state) async {
//     var locationPermission = await Geolocator.checkPermission();
//     if (state == AppLifecycleState.resumed) {
//       //**Refer to this link for permission handling: https://davidserrano.io/best-way-to-handle-permissions-in-your-flutter-app
//       //** FOR IOS
//       if (Platform.isIOS) {
//         if (locationPermission == LocationPermission.always ||
//             locationPermission == LocationPermission.whileInUse) {
//         } else {
//           await Geolocator.checkPermission();
//         }
//         //** FOR ANDROID
//       } else if (Platform.isAndroid) {
//         if (locationPermission == LocationPermission.always ||
//             locationPermission == LocationPermission.whileInUse) {
//         } else {}
//       }
//     }
//   }

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         scaffoldBackgroundColor: Colors.white,
//         useMaterial3: true,
//         textTheme: GoogleFonts.poppinsTextTheme(),
//         // fontFamily: ,
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//         primarySwatch: Colors.blue,
//       ),
//       home: const GoogleMapScreen(),
//     );
//   }
// }