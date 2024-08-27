import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'vehicle_service.db');
    // Abre o banco de dados e força a recriação com cada execução
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: (db, oldVersion, newVersion) async {
        // Força a recriação do banco de dados para garantir que todas as tabelas estejam presentes
        await db.execute('DROP TABLE IF EXISTS vehicles');
        await db.execute('DROP TABLE IF EXISTS services');
        await _onCreate(db, newVersion);
      },
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Criação da tabela vehicles
    await db.execute('''
      CREATE TABLE vehicles(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        model TEXT,
        mileage INTEGER,
        licensePlate TEXT,
        scheduledMaintenance INTEGER
      )
    ''');

    // Criação da tabela services
    await db.execute('''
      CREATE TABLE services(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        vehicleId INTEGER,
        type TEXT,
        date TEXT,
        mileage INTEGER,
        FOREIGN KEY(vehicleId) REFERENCES vehicles(id) ON DELETE CASCADE
      )
    ''');
  }
}
