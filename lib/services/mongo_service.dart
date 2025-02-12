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
    _db = await mongo.Db.create(
        'mongodb+srv://diegonicolas:lkHF513apl5CmJBE@cluster0.xqp2g.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0');
    await _db.open();
  }

  mongo.Db get db {
    if (!db.isConnected) {
      throw StateError('Base de datos no inicializa, llama a connect() orimero');
    }
    return _db;
  }

  Future<List<PhoneModel>> getPhones() async {
    final collection = _db.collection('celulares');
    var phones = await collection.find().toList();
    return phones.map((phone) => PhoneModel.fromJson(phone)).toList();
  }
}