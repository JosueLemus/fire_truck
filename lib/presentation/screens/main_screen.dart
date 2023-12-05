import 'package:animate_do/animate_do.dart';
import 'package:bomberman/presentation/screens/home_screen.dart';
import 'package:bomberman/presentation/widgets/local_notification_card.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBody(),
          Positioned(
              left: 23,
              right: 23,
              top: 40,
              child: BounceInDown(
                  child: const LocalNotificationCard(
                      title: "title", description: "description"))),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBody() {
    switch (currentIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return const Center(child: Text("Contenido del historial"));
      case 2:
        return const Center(child: Text("Contenido de notificaciones"));
      case 3:
        return const Center(child: Text("Contenido del perfil"));
      default:
        return Container();
    }
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'Historial',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Notificaciones',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
    );
  }
}
