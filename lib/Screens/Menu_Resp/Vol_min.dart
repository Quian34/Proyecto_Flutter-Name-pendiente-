import 'package:flutter/material.dart';

class Volumin extends StatelessWidget {
  const Volumin({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calcular Flujo Respiratorio',
      home: const V_min(),
    );
  }
}

class V_min extends StatefulWidget {
  const V_min({super.key});

  @override
  State<V_min> createState() => _V_minState();
}
class _V_minState extends State <V_min>{
  final TextEditingController _VTidalController = TextEditingController();
  final TextEditingController _FRespController = TextEditingController();
  final TextEditingController _paCO2ActualController = TextEditingController();
  final TextEditingController _paCO2IdealController = TextEditingController();

  double? volumenMinutoActual;
  double? _volumenMinutoIdeal;
  
  void _calcularVolumenMinuto() {
    final double? VTidal = double.tryParse(_VTidalController.text);
    final double? FResp = double.tryParse(_FRespController.text);

    if (VTidal != null && FResp != null && VTidal > 0 && FResp > 0){
      setState((){
        volumenMinutoActual = VTidal * FResp;
      });
    } else {
      setState((){
      volumenMinutoActual = null;
      });
      // Mensaje de Error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingrese valores válidos')),
      );
    }
  }

    void _calcularVolumenMinutoIdeal() {
    final double? paCO2A = double.tryParse(_paCO2ActualController.text);
    final double? paCO2I = double.tryParse(_paCO2IdealController.text);

    if (volumenMinutoActual == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Primero calcule el volumen minuto actual')),
      );
      return;
    }

    if (paCO2A != null && paCO2I != null && paCO2A > 0 && paCO2I > 0) {
      setState(() {
        _volumenMinutoIdeal = volumenMinutoActual! * (paCO2A / paCO2I);
      });
    } else {
      setState(() {
        _volumenMinutoIdeal = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingrese valores válidos para la presión parcial de CO2')),
      );
    }
  }

@override
void dispose() {
  _VTidalController.dispose();
  _FRespController.dispose();
  _paCO2ActualController.dispose();
  _paCO2IdealController.dispose();
  super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Volumen Minuto'),
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
            // Inputs para VM actual
            TextField(
              controller: _VTidalController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'VTidal (L)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _FRespController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Frecuencia Respiratoria (resp/m)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calcularVolumenMinuto,
              child: const Text('Calcular Volumen Minuto Actual'),
            ),
            const SizedBox(height: 20),
            if (volumenMinutoActual != null)
              Text(
                'Volumen minuto actual: ${volumenMinutoActual!.toStringAsFixed(2)} L/m',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

            const Divider(height: 40),

            // Inputs para paCO2 actual e ideal
            TextField(
              controller: _paCO2ActualController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'paCO2 actual (mm Hg)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _paCO2IdealController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'paCO2 ideal (mm Hg)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calcularVolumenMinutoIdeal,
              child: const Text('Calcular Volumen Minuto Ideal'),
            ),
            const SizedBox(height: 20),
            if (_volumenMinutoIdeal != null)
              Text(
                'Volumen minuto ideal: ${_volumenMinutoIdeal!.toStringAsFixed(2)} L/m',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
              ),


            const SizedBox(height: 30),
            const Text(
              'Valores de referencia',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(
                      label: Text('Condición',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Valor',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: const [
                  DataRow(cells: [
                    DataCell(Text('Persona sana')),
                    DataCell(Text('100 mL/Kg/min')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Postoperatorio cirugía electiva')),
                    DataCell(Text('100 mL/Kg/min')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Sepsis / estados proinflamatorios')),
                    DataCell(Text('150 mL/Kg/min')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('SDRA')),
                    DataCell(Text('150 mL/Kg/min')),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}