import 'package:flutter/material.dart';

class PO2Calculator extends StatefulWidget {
  const PO2Calculator({super.key});

  @override
  State<PO2Calculator> createState() => _PO2CalculatorState();
}

class _PO2CalculatorState extends State<PO2Calculator> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fio2Controller = TextEditingController();
  final TextEditingController _prAtmController = TextEditingController();

  double? _resultado;

  void calcularPO2() {
    if (_formKey.currentState!.validate()) {
      double fio2 = double.parse(_fio2Controller.text);
      double prAtm = double.parse(_prAtmController.text);

      // FiO2 se ingresa como porcentaje, se convierte a fracción
      double fio2Fraccion = fio2 / 100;

      double po2 = fio2Fraccion * prAtm;

      setState(() {
        _resultado = po2;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cálculo de PO2'),
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
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _fio2Controller,
                decoration: InputDecoration(
                  labelText: 'FiO2 (%)',
                  border: OutlineInputBorder(),
                  hintText: 'Ejemplo: 21',
                ),
                keyboardType:
                    TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      double.tryParse(value) == null) {
                    return 'Ingrese un valor válido para FiO2';
                  }
                  double val = double.parse(value);
                  if (val <= 0 || val > 100) {
                    return 'FiO2 debe estar entre 0 y 100';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _prAtmController,
                decoration: InputDecoration(
                  labelText: 'Presión Atmosférica (mmHg)',
                  border: OutlineInputBorder(),
                  hintText: 'Ejemplo: 760',
                ),
                keyboardType:
                    TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      double.tryParse(value) == null) {
                    return 'Ingrese un valor válido para presión atmosférica';
                  }
                  double val = double.parse(value);
                  if (val <= 0) {
                    return 'La presión atmosférica debe ser positiva';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: calcularPO2,
                child: Text('Calcular PO2'),
              ),
              SizedBox(height: 24),
              if (_resultado != null)
                Text(
                  'PO2 calculado: ${_resultado!.toStringAsFixed(2)} mmHg',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700]),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
