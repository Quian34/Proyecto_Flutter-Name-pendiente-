import 'package:flutter/material.dart';

void main() => runApp(MovimientoRespiratorioApp());


class MovimientoRespiratorioApp extends StatelessWidget {
  const MovimientoRespiratorioApp({super.key});

  @override
  
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RespiratoryCalculator(),
    );
  }
}

class RespiratoryCalculator extends StatefulWidget {
  const RespiratoryCalculator({super.key});

  @override

  State<RespiratoryCalculator> createState() => _RespiratoryCalculatorState();
}

class _RespiratoryCalculatorState extends State<RespiratoryCalculator> {
  final TextEditingController _volumenController = TextEditingController();
  final TextEditingController _tiempoController = TextEditingController();

  double? _resultado;

  void _calcularFlujoInspiratorio() {
    final double? volumen = double.tryParse(_volumenController.text);
    final double? tiempo = double.tryParse(_tiempoController.text);

    if (volumen != null && tiempo != null && tiempo > 0) {
      setState(() {
        _resultado = volumen / tiempo; // Vinsp = Vt / tinsp
      });
    } else {
      setState(() {
        _resultado = null;
      });
      // Aquí podrías mostrar un mensaje de error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calculadora Movimiento Respiratorio'),
        actions: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          tooltip: 'Regresar',
        ),
      ],
    ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset('pics/formula_1.png', height: 150), // Imagen de la fórmula
            SizedBox(height: 20),
            TextField(
              controller: _volumenController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Volumen tidal (Vt) en litros',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _tiempoController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Tiempo inspiratorio (tinsp) en segundos',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calcularFlujoInspiratorio,
              child: Text('Calcular flujo inspiratorio'),
            ),
            SizedBox(height: 20),
            if (_resultado != null)
              Text(
                'Flujo inspiratorio: ${_resultado!.toStringAsFixed(2)} L/s',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}