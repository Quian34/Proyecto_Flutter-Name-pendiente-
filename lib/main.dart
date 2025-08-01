import 'package:app_padre/Screens/CalculadoraPesoIMC.dart';
import 'package:app_padre/Screens/Calc_Respiratorio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Titulo_App',
      home: const MainMenu(),
    );
  }
}

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú Principal'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CalculadoraPesoIMC()),
                );
              },
              child: const Text('Peso Ideal e IMC'),
            ),
            const SizedBox(height: 20), // Espacio entre botones
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Calc_Respiratorio()),
                  );                
              },
              child: const Text('Herramientas de Cálculo'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Calc_Respiratorio()),
                  );       
              },
              child: const Text('Acerca De'),
            ),
          ],
        ),
      ),
    );
  }
}