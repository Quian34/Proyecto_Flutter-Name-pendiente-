import 'package:flutter/material.dart';
import 'Menu_Resp/Index.dart';

class Calc_Respiratorio extends StatelessWidget {
  const Calc_Respiratorio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Herramientas de Cálculo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RespiratoryCalculator()),
                );
              },
              child: const Text('Movimiento Respiratorio'),
            ),
            const SizedBox(height: 20), // Espacio entre botones
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const VolTidal()),
                  );                
              },
              child: const Text('Volumen Tidal'),
            ),
            const SizedBox(height: 20), // Espacio entre botones
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PO2Calculator()),
                  );                
              },
              child: const Text('%O2 Inspirado'),
            ),
            const SizedBox(height: 20), // Espacio entre botones
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FlujoInsp()),
                  );                
              },
              child: const Text('Flujo Inspiratorio'),
            ),
            const SizedBox(height: 20), // Espacio entre botones
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CalculadoraPresionPage()),
                  );                
              },
              child: const Text('Flujo Inspiratorio'),
            ),
          ],
        ),
      ),
    );
  }
}