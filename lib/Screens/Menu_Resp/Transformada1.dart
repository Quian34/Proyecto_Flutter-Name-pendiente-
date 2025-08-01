//ml/sg a L/m
import 'package:flutter/material.dart';
class Transformada extends StatefulWidget {
  const Transformada({super.key});

  @override
  State<Transformada> createState() => _TransformadaState();
}

class _TransformadaState extends State<Transformada> {
  final TextEditingController _mlsgController = TextEditingController();
  final TextEditingController _LminController = TextEditingController();

  //esto evita actualización recursiva en ambos campos
  bool _isEditingMlsg = false;
  bool _isEditingLmin = false;

@override
void initState() {
  super.initState();

  _mlsgController.addListener(() {
    if (_isEditingLmin) return; //avoid bucles
    _isEditingMlsg = true;

    final texto = _mlsgController.text;
    final valor = double.tryParse(texto);
    if (valor != null) {
      // Vi(L/m) = (Vi(ml/sg) *60 /1000)
      final convertido = (valor * 60) / 1000;
      _LminController.text = convertido.toStringAsFixed(3);
    } else {
      _LminController.text = '';
    }
    _isEditingMlsg = false;

  });
  _LminController.addListener(() {
    if (_isEditingMlsg) return;
    _isEditingLmin = true;

    final texto = _LminController.text;
    final valor = double.tryParse(texto);
    if (valor != null) {

      final convertido = (valor * 1000) /60;
      _mlsgController.text = convertido.toStringAsFixed(3);
    } else {
      _mlsgController.text = '';
    }

    _isEditingLmin = false;
  });
}

@override
  void dispose() {
    _mlsgController.dispose();
    _LminController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conversión ml/s ↔ L/min'),
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
            TextField(
              controller: _mlsgController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Flujo en ml/seg',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _LminController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Flujo en L/min',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}