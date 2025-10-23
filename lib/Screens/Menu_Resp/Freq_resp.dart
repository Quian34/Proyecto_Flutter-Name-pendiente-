import 'package:flutter/material.dart';


class Flujoinspira extends StatelessWidget {
  const Flujoinspira({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calcular Flujo Respiratorio',
      home: const Freq(),
    );
  }
}
class Freq extends StatefulWidget {
  const Freq({super.key});

  @override
  State<Freq> createState() => _FreqState();
}

class _FreqState extends State<Freq> {

  //valores normales
  final TextEditingController _vminController = TextEditingController();
  final TextEditingController _vtidalController = TextEditingController();

    // Controladores para segundo cálculo - FR(i)
  final TextEditingController _fraController = TextEditingController();
  final TextEditingController _pacoaController = TextEditingController();
  final TextEditingController _pacoIController = TextEditingController();


  double? _resultado; //resultado normal
  double? _resultadoIdeal; //resultado cálculo ideal

  void _calcularFreqresp() {
    final double? vmin = double.tryParse(_vminController.text);
    final double? vtidal = double.tryParse(_vtidalController.text);
    if (vmin != null && vtidal != null && vtidal > 0) {
      setState(() {
        _resultado = vmin / vtidal; // Freq_Resp = vmin / vtidal
      });
    } else {
      setState(() {
        _resultado = null;
      });
      // Mensaje de Error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingrese valores válidos (tiempo > 0)')),
      );
    }
  }
void _calcularFreqRespIdeal() {
    final double? fra = double.tryParse(_fraController.text);
    final double? pacoa = double.tryParse(_pacoaController.text);
    final double? pacoi = double.tryParse(_pacoIController.text);

    if (fra != null && pacoa != null && pacoi != null && pacoi != 0) {
      setState(() {
        _resultadoIdeal = (fra * pacoa) / pacoi;
      });
    } else {
      setState(() {
        _resultadoIdeal = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingrese valores válidos, y paCO2(i) diferente de cero')),
      );
    }
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calcular Frecuencia Respiratoria'),
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
            //Image.asset('pics/formula_1.png', height: 150),
            const SizedBox(height: 20),
            TextField(
              controller: _vminController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Volumen Minuto (L/m)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _vtidalController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Volumen Tidal (L)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calcularFreqresp,
              child: const Text('Calcular flujo inspiratorio'),
            ),
            const SizedBox(height: 20),
            if (_resultado != null)
              Text(
                'Frecuencia Respiratoria: ${_resultado!.toStringAsFixed(2)} L/s',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ), const SizedBox(height: 40),
              const Divider(height: 40, thickness: 2),



            // Segundo calculador - Frecuencia Respiratoria Ideal
            const Text(
              'Calcular Frecuencia Respiratoria Ideal (FR(i))',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 20),
            // FR(a)
            TextField(
              controller: _fraController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'FR(a) - Frecuencia Respiratoria actual (resp/m)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            // paCO2(a)
            TextField(
              controller: _pacoaController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'paCO2(a) - Presión parcial de CO2 actual (mm Hg)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            // paCO2(i)
            TextField(
              controller: _pacoIController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'paCO2(i) - Presión parcial de CO2 ideal (mm Hg)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calcularFreqRespIdeal,
              child: const Text('Calcular Frecuencia Respiratoria Ideal'),
            ),
            const SizedBox(height: 20),
            if (_resultadoIdeal != null)
              Text(
                'FR(i) ideal: ${_resultadoIdeal!.toStringAsFixed(2)} resp/m',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
              ),
          Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Fórmula para Frecuencia Respiratoria Ideal (FR(i))',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'FR(i) = [FR(a) × paCO2(a)] / paCO2(i)',
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Donde:\n'
                    '- FR(a): Frecuencia Respiratoria actual programada en el ventilador (resp/m)\n'
                    '- paCO2(a): presión parcial de CO2 actual (mm Hg)\n'
                    '- FR(i): Frecuencia Respiratoria ideal (resp/m)\n'
                    '- paCO2(i): presión parcial de CO2 ideal o deseada (mm Hg)',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}