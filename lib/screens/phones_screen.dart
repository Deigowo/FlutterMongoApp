import 'package:flutter/material.dart';
import 'package:mongo_app/models/phone_model.dart';
import 'package:mongo_app/screens/insert_phone_screen.dart';
import 'package:mongo_app/services/mongo_service.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> { 
  List<PhoneModel> phones = [];
  late TextEditingController _marcaController;
  late TextEditingController _modeloController;
  late TextEditingController _unidadesController;
  late TextEditingController _precioController;

  @override
  void initState() {
    super.initState();
    _fetchPhones();
    _marcaController = TextEditingController();
    _modeloController = TextEditingController();
    _unidadesController = TextEditingController();
    _precioController = TextEditingController();
    _fetchPhones();
  }

  @override
  void dispose(){
    // Destruir la screen cuando la app salga de esta ventana
    _marcaController.dispose();
    _modeloController.dispose();
    _unidadesController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario de telefonos'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const InsertPhoneScreen(), 
                  )
                );
                _fetchPhones();
              },
              child: const Icon(
                Icons.add,
                size: 26.0,
                ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
      itemCount: phones.length,
      itemBuilder: (context, index){
        var phone = phones[index];
        return oneTile(phone);
      },
      ),
    );
  }
  
  void _fetchPhones() async {
    phones = await MongoService().getPhones();
    print('En fetch: $phones');
    setState(() {});
  }

  void _deletePhone(mongo.ObjectId id) async {
    await MongoService().deletePhone(id);
    _fetchPhones(); 
  }

  void _updatePhone(PhoneModel phone) async {
    await MongoService().updatePhone(phone);
    _fetchPhones(); 
  }

  void _showEditDialog(PhoneModel phone) {
    _marcaController.text = phone.marca;
    _modeloController.text = phone.modelo;
    _unidadesController.text = phone.unidades.toString();
    _precioController.text = phone.precio.toString();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar teléfono'),
          content: Column(
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Marca'),
                controller: _marcaController,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Modelo'),
                controller: _modeloController,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Unidades'),
                controller: _unidadesController,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Precio'),
                controller: _precioController,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // Recuperar los nuevos valores
                phone.marca = _marcaController.text;
                phone.modelo = _modeloController.text;
                phone.unidades = int.parse(_unidadesController.text);
                phone.precio = double.parse(_precioController.text);
                _updatePhone(phone);
                Navigator.pop(context);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  ListTile oneTile(var phone){
    return ListTile(
      title: Text(phone.marca),
      subtitle: Text(phone.modelo),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => _showEditDialog(phone), 
            icon: Icon(Icons.edit)
          ),
          IconButton(
            onPressed: () {
              _deletePhone(phone.id);
            },
            icon: Icon(Icons.delete)
          ),
        ],
      ),
    );
  }
}