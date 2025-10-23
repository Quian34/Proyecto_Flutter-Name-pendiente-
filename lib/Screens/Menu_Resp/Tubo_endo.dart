import 'package:flutter/material.dart';
import 'dart:math';

class espacio_tubo extends StatelessWidget {
  const espacio_tubo({super.key});

  @override
  Widget build(BuildContext context) {
    return const endotraquial();
  }
}
class endotraquial extends StatefulWidget {
  const endotraquial({super.key});

  @override
  State<endotraquial> createState() => _endotraquialState();
}
class _endotraquialState extends State <endotraquial>{
  final TextEditingController _radioController = TextEditingController();
  final TextEditingController _longController = TextEditingController();

  double? _resultado;
  void _VolumenInt() {
    final double? radio = double.tryParse(_radioController.text);
    final double? long = double.tryParse(_longController.text);

    if (radio != null && long != null && radio > 0 && long > 0){
      setState((){
        _resultado = pi * pow(radio, 2) * long;
      });
    } else {
      setState((){
      _resultado = null;
      });
      // Mensaje de Error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingrese valores válidos (tiempo > 0)')),
      );
    }
  }

@override
void dispose() {
  _radioController.dispose();
  _longController.dispose();
  super.dispose();
  }
@override
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Volumen Interno Endotraquial'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          tooltip: 'Regresar',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _radioController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Radio (cm)',
                border: OutlineInputBorder(),
                ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _longController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'longitud del tubo endotraqueal (cm)',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _VolumenInt,
              child: const Text('Calcular volumen'),
            ),
            const SizedBox(height: 20),
            if (_resultado != null)
              Text(
                'Volumen interno: ${_resultado!.toStringAsFixed(2)} cm³',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}