import 'package:flutter/material.dart';

class FlujoInsp extends StatelessWidget {
  const FlujoInsp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calcular Flujo Respiratorio',
      home: const Flujo(),
    );
  }
}

class Flujo extends StatefulWidget {
  const Flujo({super.key});

  @override
  State<Flujo> createState() => _FlujoState();
}

enum TipoCalculo {
  flujoInspiratorio,
  flujoMinimoFormula1,
  flujoMinimoFormula2,
}

class _FlujoState extends State<Flujo> {
  final TextEditingController _volumenController = TextEditingController(); // Vt o VM
  final TextEditingController _tiempoController = TextEditingController(); // Tiempo inspiración (para fórmula actual)
  final TextEditingController _frController = TextEditingController(); // Frecuencia respiratoria (FR)
  final TextEditingController _numPartesController = TextEditingController(); // Nº de partes de R I:E

  TipoCalculo _tipoCalculo = TipoCalculo.flujoInspiratorio;
  double? _resultado;

  void _calcular() {
    setState(() {
      switch (_tipoCalculo) {
        case TipoCalculo.flujoInspiratorio:
          final double? volumen = double.tryParse(_volumenController.text);
          final double? tiempo = double.tryParse(_tiempoController.text);
          if (volumen == null || tiempo == null || tiempo <= 0) {
            _resultado = null;
            _mostrarError('Ingrese valores válidos (tiempo > 0)');
          } else {
            _resultado = volumen / tiempo;
          }
          break;
        case TipoCalculo.flujoMinimoFormula1:
          final double? VM = double.tryParse(_volumenController.text);
          final double? numPartes = double.tryParse(_numPartesController.text);
          if (VM == null || numPartes == null || numPartes <= 0) {
            _resultado = null;
            _mostrarError('Ingrese valores válidos para VM y número de partes');
          } else {
            _resultado = VM * numPartes;
          }
          break;
        case TipoCalculo.flujoMinimoFormula2:
          final double? VT = double.tryParse(_volumenController.text);
          final double? FR = double.tryParse(_frController.text);
          final double? numPartes2 = double.tryParse(_numPartesController.text);
          if (VT == null || FR == null || numPartes2 == null || FR <= 0 || numPartes2 <= 0) {
            _resultado = null;
            _mostrarError('Ingrese valores válidos para VT, FR y número de partes');
          } else {
            _resultado = VT * FR * numPartes2;
          }
          break;
      }
    });
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  Widget _buildCamposInputs() {
    switch (_tipoCalculo) {
      case TipoCalculo.flujoInspiratorio:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _volumenController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Volumen tidal (Vt) en litros',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _tiempoController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Tiempo de inspiración (s)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        );
      case TipoCalculo.flujoMinimoFormula1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _volumenController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Volumen minuto (VM) en litros',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _numPartesController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Número de partes R I:E',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        );
      case TipoCalculo.flujoMinimoFormula2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _volumenController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Volumen tidal (VT) en litros',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _frController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Frecuencia respiratoria (FR) en respiraciones/minuto',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _numPartesController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Número de partes R I:E',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        );
    }
  }

  @override
  void dispose() {
    _volumenController.dispose();
    _tiempoController.dispose();
    _frController.dispose();
    _numPartesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calcular Flujo Respiratorio'),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Selector de fórmula
            const Text('Seleccione tipo de cálculo:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButton<TipoCalculo>(
              value: _tipoCalculo,
              isExpanded: true,
              onChanged: (TipoCalculo? nuevoValor) {
                if (nuevoValor != null) {
                  setState(() {
                    _tipoCalculo = nuevoValor;
                    _resultado = null;
                    // Limpiar todos los campos para evitar datos incorrectos
                    _volumenController.clear();
                    _tiempoController.clear();
                    _frController.clear();
                    _numPartesController.clear();
                  });
                }
              },
              items: const [
                DropdownMenuItem(
                  value: TipoCalculo.flujoInspiratorio,
                  child: Text('Flujo Inspiratorio (Vt/ tinsp)'),
                ),
                DropdownMenuItem(
                  value: TipoCalculo.flujoMinimoFormula1,
                  child: Text('Flujo Inspiratorio Mínimo (Vi = VM × partes I:E)'),
                ),
                DropdownMenuItem(
                  value: TipoCalculo.flujoMinimoFormula2,
                  child: Text('Flujo Inspiratorio Mínimo (Vi = VT × FR × partes I:E)'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Inputs para la fórmula seleccionada
            _buildCamposInputs(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calcular,
              child: const Text('Calcular'),
            ),
            const SizedBox(height: 20),
            if (_resultado != null)
              Text(
                'Resultado: ${_resultado!.toStringAsFixed(2)} L/s',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}