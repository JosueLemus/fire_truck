import 'package:flutter/material.dart';

class NoEmergenciesScreen extends StatelessWidget {
  const NoEmergenciesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              child: Image.asset("assets/bomberos_icono_gray.png"),
            ),
            const SizedBox(height: 20),
            const Text(
              "¡No tienes emergencias pendientes por atender!",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              "Cuando tengas una emergencia asignada, aparecerá en esta pantalla.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Agrega aquí la lógica para refrescar la pantalla
              },
              child: const Text(
                "Refrescar pantalla",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
