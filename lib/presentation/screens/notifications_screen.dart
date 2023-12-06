import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Data model for notifications
class NotificationData {
  final String title;
  final String description;
  final String imageUrl;

  NotificationData({
    required this.title,
    required this.description,
    required this.imageUrl,
  });
}

// Provider para manejar el estado de las notificaciones
final notificationsProvider =
    FutureProvider<List<NotificationData>>((ref) async {
  // Simular una solicitud HTTP (puedes reemplazar esto con una solicitud real)
  final response =
      await http.get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));

  if (response.statusCode == 200) {
    // Parsear los datos y retornar la lista de notificaciones
    final List<dynamic> data = jsonDecode(response.body);
    return List.generate(5, (index) {
      final item = data[index % data.length];
      return NotificationData(
        title: 'Notificación $index',
        description: 'Descripción de la notificación $index',
        imageUrl: item['thumbnailUrl'],
      );
    });
  } else {
    throw Exception('Failed to load notifications');
  }
});

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        home: NotificationScreen(),
      ),
    ),
  );
}

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notificaciones'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer(
          builder: (context, ref, _) {
            final notificationsAsyncValue = ref.watch(notificationsProvider);

            return notificationsAsyncValue.when(
              data: (notifications) {
                return ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return NotificationCard(notification: notification);
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stackTrace) => Center(
                child: Text('Error al cargar las notificaciones'),
              ),
            );
          },
        ),
      ),
    );
  }

  // Widget _buildLoadingSkeleton() {
  //   return ListView.builder(
  //     itemCount: 5,
  //     itemBuilder: (context, index) {
  //       return Shimmer.fromColors(
  //         baseColor: Colors.grey[300]!,
  //         highlightColor: Colors.grey[100]!,
  //         child: NotificationCard.loading(),
  //       );
  //     },
  //   );
  // }
}

class NotificationCard extends StatelessWidget {
  final NotificationData notification;

  NotificationCard({required this.notification});

  // Método para mostrar una tarjeta de carga (skeleton) durante la carga de datos
  factory NotificationCard.loading() {
    return NotificationCard(
      notification: NotificationData(
        title: '',
        description: '',
        imageUrl: '',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        // leading: _buildNotificationImage(),
        title: Text(notification.title),
        subtitle: Text(notification.description),
      ),
    );
  }

  // Widget _buildNotificationImage() {
  //   if (notification.imageUrl.isNotEmpty) {
  //     return CachedNetworkImage(
  //       imageUrl: notification.imageUrl,
  //       width: 56,
  //       height: 56,
  //       fit: BoxFit.cover,
  //       placeholder: (context, url) => _buildImagePlaceholder(),
  //       errorWidget: (context, url, error) => _buildImageErrorPlaceholder(),
  //     );
  //   } else {
  //     return _buildImagePlaceholder();
  //   }
  // }

  Widget _buildImagePlaceholder() {
    return Container(
      width: 56,
      height: 56,
      color: Colors.grey[300],
    );
  }

  Widget _buildImageErrorPlaceholder() {
    return Container(
      width: 56,
      height: 56,
      color: Colors.grey[300],
      child: Icon(
        Icons.error,
        color: Colors.red,
      ),
    );
  }
}
