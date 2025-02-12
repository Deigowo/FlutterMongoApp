import 'package:flutter/material.dart';
import 'package:mongo_app/models/phone_model.dart';
import 'package:mongo_app/services/mongo_service.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  List<PhoneModel> phones = [];

  @override
  void initState() {
    super.initState();
    _fetchPhones();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario de telefonos'),
      ),
    );
  }
  
  void _fetchPhones() async {
    phones = await MongoService().getPhones();

  }
}