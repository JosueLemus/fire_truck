import 'package:animate_do/animate_do.dart';
import 'package:bomberman/presentation/screens.dart';
import 'package:bomberman/presentation/widgets/local_notification_card.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationsProvider = StateProvider<RemoteMessage?>((ref) => null);

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    subscribeToFirebaseMessaging();
  }

  void subscribeToFirebaseMessaging() async {
    final token = await FirebaseMessaging.instance.getToken();
    print("token");
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      ref.read(notificationsProvider.notifier).state = message;
      Future.delayed(const Duration(seconds: 10), () {
        ref.read(notificationsProvider.notifier).state = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifications = ref.watch(notificationsProvider);
    return Scaffold(
      body: Stack(
        children: [
          _buildBody(),
          if (notifications != null)
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
        return const NoEmergenciesScreen();
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
