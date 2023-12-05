import 'package:flutter/material.dart';

class LocalNotificationCard extends StatelessWidget {
  final String title;
  final String description;

  const LocalNotificationCard(
      {super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    description,
                  )
                ],
              ),
            ),
            const Icon(
              Icons.notifications_active_outlined,
              size: 32,
            )
          ],
        ),
      ),
    );
  }
}
