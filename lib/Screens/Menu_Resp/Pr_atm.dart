import 'package:flutter/material.dart';

class CalculadoraPresionPage extends StatefulWidget {
  const CalculadoraPresionPage({super.key});

  @override
  State<CalculadoraPresionPage> createState() => _CalculadoraPresionPageState();
}

class _CalculadoraPresionPageState extends State<CalculadoraPresionPage> {
  final TextEditingController _altitudController = TextEditingController();
  double? _presion;

  void _calcularPresion() {
    final altitud = double.tryParse(_altitudController.text);
    if (altitud == null) {
      // Mostrar error si la entrada no es válida
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, ingresa un número válido para la altitud')),
      );
      return;
    }
    setState(() {
      _presion = 760 - (altitud * 0.07);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora de Presión'),
        actions: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          tooltip: 'Regresar',
        ),
      ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Regresa a main.dart o pantalla anterior
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Espacio para imagen de la fórmula
            SizedBox(
              height: 150,
              child: Image.asset(
                'assets/imagen_formula.png', // Cambia por la ruta de tu imagen
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _altitudController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Altitud (metros)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calcularPresion,
              child: Text('Calcular Presión'),
            ),
            SizedBox(height: 20),
            if (_presion != null)
              Text(
                'Presión atmosférica: ${_presion!.toStringAsFixed(2)} mmHg',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}