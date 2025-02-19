import 'dart:io';
import 'package:mongo_app/models/phone_model.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class MongoService {
  //Servicio para conectar con MongoDB Atlas
  //usando Singleton
  static final MongoService _instance = MongoService._internal();

  late mongo.Db _db;

  MongoService._internal();

  factory MongoService() {
    return _instance;
  }

  Future<void> connect() async {
   try {
    _db = await mongo.Db.create(
        'mongodb+srv://diegonicolas:lkHF513apl5CmJBE@cluster0.xqp2g.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0');
    await _db.open();
    _db.databaseName = 'productos';
    print('Conectado a MongoDB Atlas');
    } on SocketException catch(e) {
      print('Error de conexión: $e');
      rethrow;
    }
  }

  mongo.Db get db {
    if (!db.isConnected) {
      throw StateError('Base de datos no inicializa, llama a connect() primero');
    }
    return _db;
  }

  Future<List<PhoneModel>> getPhones() async {
    final collection = _db.collection('calulares');
    print('Colección obtenida: $collection');
    var phones = await collection.find().toList();
    print('En MongoService: $phones');
    if (phones.isEmpty) {
      print('No se encontraron celulares en la base de datos');
    }
    return phones.map((phone) => PhoneModel.fromJson(phone)).toList();
  }

  Future<void> insertPhone(PhoneModel phone) async {
    _db.databaseName=('productos');
    final collection = _db.collection('calulares');
    await collection.insertOne(phone.toJson());
  }

  Future<void> updatePhone(PhoneModel phone) async {
    final collection = _db.collection('calulares');
    await collection.updateOne(
      mongo.where.eq('_id', phone.id),
      mongo.modify
        .set('marca', phone.marca)
        .set('modelo', phone.modelo)
        .set('unidades', phone.unidades)
        .set('precio', phone.precio)
    );
  }

  Future<void> deletePhone(mongo.ObjectId id) async {
    var collection = db.collection('calulares');
    await collection.remove(mongo.where.eq('_id', id));
  }
}