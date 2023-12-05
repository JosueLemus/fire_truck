import 'package:bomberman/config/navigation/application_routes.dart';
import 'package:bomberman/config/services/local_storage_services.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const name = 'splash-screen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      verifyLogin();
    });
  }

  void verifyLogin() async {
    final token = await LocalStorageServices.getLocalData(KeyTypes.userToken);
    if (mounted) {
      if (token != null) {
        Navigator.pushReplacementNamed(context, Routes.main);
      } else {
        Navigator.pushReplacementNamed(context, Routes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  width: 200,
                  child: Image.asset("assets/bomberos_icono_gray.png")),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
