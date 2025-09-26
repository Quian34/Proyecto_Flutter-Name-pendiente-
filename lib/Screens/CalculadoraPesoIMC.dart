import 'package:flutter/material.dart';

void main() {
  runApp(CalculadoraPesoIMC());
}

class CalculadoraPesoIMC extends StatefulWidget {
  const CalculadoraPesoIMC({super.key});

  @override
  _CalculadoraPesoIMCState createState() => _CalculadoraPesoIMCState();
}
enum Sexo { hombre, mujer }

class _CalculadoraPesoIMCState extends State<CalculadoraPesoIMC> {
  final pesoController = TextEditingController();
  final alturaController = TextEditingController();
  Sexo? sexoSeleccionado;

  double? imc;
  String pesoIdeal = '';

    void calcular() {
    final double? peso = double.tryParse(pesoController.text);
    final double? alturaCm = double.tryParse(alturaController.text);

    if (peso != null && alturaCm != null && alturaCm > 0 && sexoSeleccionado != null) {
      final alturaM = alturaCm / 100;
      setState(() {
        imc = peso / (alturaM * alturaM);

        if (sexoSeleccionado == Sexo.hombre) {
          pesoIdeal = '${(50 + 0.92 * (alturaCm - 150)).toStringAsFixed(2)} kg';
        } else {
          pesoIdeal = '${(45.5 + 0.92 * (alturaCm - 150)).toStringAsFixed(2)} kg';
        }
      });
    }
  }
    @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Calculadora Peso Ideal e IMC'),
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
          child: Column(
            children: [
              
              TextField(
                controller: pesoController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Peso (kg)'),
              ),
              TextField(
                controller: alturaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Altura (cm)'),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<Sexo>(
                      title: Text('Hombre'),
                      value: Sexo.hombre,
                      groupValue: sexoSeleccionado,
                      onChanged: (Sexo? value) {
                        setState(() {
                          sexoSeleccionado = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<Sexo>(
                      title: Text('Mujer'),
                      value: Sexo.mujer,
                      groupValue: sexoSeleccionado,
                      onChanged: (Sexo? value) {
                        setState(() {
                          sexoSeleccionado = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: calcular,
                child: Text('Calcular'),
              ),
              SizedBox(height: 20),
              if (imc != null) Text('IMC: ${imc!.toStringAsFixed(2)}'),
              if (pesoIdeal.isNotEmpty) Text('Peso Ideal aproximado: $pesoIdeal'),
            ],
          ),
        ),
      ),
    );
  }
}