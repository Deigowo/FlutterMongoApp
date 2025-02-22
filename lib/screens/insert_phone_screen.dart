import 'package:flutter/material.dart';
import 'package:mongo_app/models/phone_model.dart';
import 'package:mongo_app/services/mongo_service.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class InsertPhoneScreen extends StatefulWidget {
  const InsertPhoneScreen({super.key});

  @override
  State<InsertPhoneScreen> createState() => _InsertPhoneScreenState();
}

class _InsertPhoneScreenState extends State<InsertPhoneScreen> {

  late TextEditingController _marcaController;
  late TextEditingController _modeloController;
  late TextEditingController _existenciaController;
  late TextEditingController _precioController;

  @override
  void initState(){
    super.initState();
    _marcaController = TextEditingController();
    _modeloController = TextEditingController();
    _existenciaController = TextEditingController();
    _precioController = TextEditingController();
  }

  @override
  void dispose(){
    _marcaController.dispose();
    _modeloController.dispose();
    _existenciaController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  void _insertPhone() async {
    var phone = PhoneModel(
      id: mongo.ObjectId(), 
      marca: _marcaController.text,
      modelo: _modeloController.text,
      unidades: int.parse(_existenciaController.text),
      precio: double.parse(_precioController.text),
    );
    await MongoService().insertPhone(phone);
    if (!mounted) return;
    // El pop destruye la screen actual y regresa a la anterior
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insertar nuevo teléfono'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _marcaController,
              decoration: const InputDecoration(
                labelText: 'Marca',
              ),
            ),
            TextField(
              controller: _modeloController,
              decoration: const InputDecoration(
                labelText: 'Modelo',
              ),
            ),
            TextField(
              controller: _existenciaController,
              decoration: const InputDecoration(
                labelText: 'Unidades',
              ),
            ),
            TextField(
              controller: _precioController,
              decoration: const InputDecoration(
                labelText: 'Precio',
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _insertPhone,
              child: const Text('Insertar'),
            ),
          ],
        ),
      ),
    );
  }
}