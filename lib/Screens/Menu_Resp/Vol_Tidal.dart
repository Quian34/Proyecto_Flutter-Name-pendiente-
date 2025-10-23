import 'package:flutter/material.dart';

class VolTidal extends StatefulWidget {
  const VolTidal({super.key});

  @override
  State<VolTidal> createState() => _VolTidalState();
}

class _VolTidalState extends State<VolTidal> {
  final _formKey = GlobalKey<FormState>();

  // Controladores originales
  final TextEditingController _vtProgController = TextEditingController();
  final TextEditingController _prPicoController = TextEditingController();
  final TextEditingController _peepController = TextEditingController();
  final TextEditingController _factorController = TextEditingController();

  // Nuevos controladores para cálculo VT ideal
  final TextEditingController _vtActualController = TextEditingController();
  final TextEditingController _paCO2ActualController = TextEditingController();
  final TextEditingController _paCO2IdealController = TextEditingController();

  double? _resultado;
  double? _resultadoVTideal;

  void calcularVolumenTidalSuministrado() {
    if (_formKey.currentState!.validate()) {
      double vtProg = double.parse(_vtProgController.text);
      double prPico = double.parse(_prPicoController.text);
      double peep = double.parse(_peepController.text);
      double factor = double.parse(_factorController.text);

      double vtSumin = vtProg - ((prPico - peep) * factor);

      setState(() {
        _resultado = vtSumin;
      });
    }
  }

  void calcularVolumenTidalIdeal() {
    final String vtActualText = _vtActualController.text;
    final String paCO2ActualText = _paCO2ActualController.text;
    final String paCO2IdealText = _paCO2IdealController.text;

    if (vtActualText.isEmpty ||
        paCO2ActualText.isEmpty ||
        paCO2IdealText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, complete todos los campos para Volumen Tidal Ideal')),
      );
      return;
    }

    final double? vtActual = double.tryParse(vtActualText);
    final double? paCO2A = double.tryParse(paCO2ActualText);
    final double? paCO2I = double.tryParse(paCO2IdealText);

    if (vtActual == null || paCO2A == null || paCO2I == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingrese valores numéricos válidos')),
      );
      return;
    }

    if (paCO2I == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('paCO2 ideal no puede ser cero')),
      );
      return;
    }

    final double vtIdeal = vtActual * paCO2A / paCO2I;

    setState(() {
      _resultadoVTideal = vtIdeal;
    });
  }

  @override
  void dispose() {
    _vtProgController.dispose();
    _prPicoController.dispose();
    _peepController.dispose();
    _factorController.dispose();

    _vtActualController.dispose();
    _paCO2ActualController.dispose();
    _paCO2IdealController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cálculo Volumen Tidal'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          tooltip: 'Regresar',
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Image.asset('/pics/formula_2.png', height: 150),
              // Sección Volumen Tidal Suministrado (original)
              TextFormField(
                controller: _vtProgController,
                decoration: const InputDecoration(
                  labelText: 'Volumen Tidal Programado (ml)',
                  border: OutlineInputBorder(),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      double.tryParse(value) == null ||
                      double.parse(value) < 0) {
                    return 'Ingrese un volumen tidal programado válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _prPicoController,
                decoration: const InputDecoration(
                  labelText: 'Presión Inspiratoria Pico (cmH2O)',
                  border: OutlineInputBorder(),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      double.tryParse(value) == null) {
                    return 'Ingrese una presión pico válida';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _peepController,
                decoration: const InputDecoration(
                  labelText: 'PEEP (cmH2O)',
                  border: OutlineInputBorder(),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      double.tryParse(value) == null) {
                    return 'Ingrese un valor de PEEP válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _factorController,
                decoration: const InputDecoration(
                  labelText: 'Factor de distensibilidad (ml/cmH2O)',
                  border: OutlineInputBorder(),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      double.tryParse(value) == null ||
                      double.parse(value) < 0) {
                    return 'Ingrese un factor válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: calcularVolumenTidalSuministrado,
                child: const Text('Calcular Volumen Tidal Suministrado'),
              ),
              const SizedBox(height: 24),
              if (_resultado != null)
                Text(
                  'Volumen Tidal Suministrado: ${_resultado!.toStringAsFixed(2)} ml',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent),
                  textAlign: TextAlign.center,
                ),

              const Divider(height: 40, thickness: 2),

              // --- Nueva sección Volumen Tidal Ideal ---
              const Text(
                'Cálculo Volumen Tidal Ideal (VT(i))',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _vtActualController,
                decoration: const InputDecoration(
                  labelText: 'VT actual programado (ml)',
                  border: OutlineInputBorder(),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _paCO2ActualController,
                decoration: const InputDecoration(
                  labelText: 'paCO2 actual (mm Hg)',
                  border: OutlineInputBorder(),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _paCO2IdealController,
                decoration: const InputDecoration(
                  labelText: 'paCO2 ideal (mm Hg)',
                  border: OutlineInputBorder(),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: calcularVolumenTidalIdeal,
                child: const Text('Calcular Volumen Tidal Ideal'),
              ),
              const SizedBox(height: 24),

              if (_resultadoVTideal != null)
                Text(
                  'Volumen Tidal Ideal (VT(i)): ${_resultadoVTideal!.toStringAsFixed(2)} ml',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}