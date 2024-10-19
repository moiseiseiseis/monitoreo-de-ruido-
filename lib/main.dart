import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para manejar fechas
import 'database_helper.dart'; // Importa el archivo con la lógica de la base de datos

void main() {
  runApp(const MonitoreoRuidoApp());
}

class MonitoreoRuidoApp extends StatelessWidget {
  const MonitoreoRuidoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MonitoreoRuidoHome(),
    );
  }
}

class MonitoreoRuidoHome extends StatefulWidget {
  const MonitoreoRuidoHome({super.key});

  @override
  _MonitoreoRuidoHomeState createState() => _MonitoreoRuidoHomeState();
}

class _MonitoreoRuidoHomeState extends State<MonitoreoRuidoHome> {
  String _selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final TextEditingController _decibelController = TextEditingController();
  final _databaseHelper = DatabaseHelper(); // Instancia de la clase de ayuda para la base de datos

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _selectedDate = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitoreo de Ruido'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Selecciona una fecha:'),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text('Fecha: $_selectedDate'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _decibelController,
              decoration: const InputDecoration(
                labelText: 'Introduce nivel de decibeles (Leq)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final double decibeles =
                    double.tryParse(_decibelController.text) ?? 0.0;
                _databaseHelper.saveData(_selectedDate, decibeles); // Guarda los datos en la base de datos
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Datos guardados correctamente')),
                );
                _decibelController.clear();
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _decibelController.dispose();
    super.dispose();
  }
}
