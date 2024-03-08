import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:text_copypaster/models/Equipment.dart';
import 'package:text_copypaster/models/equipmentService.dart';
import 'package:text_copypaster/models/service.dart';

class DatabaseHelper {
  static Database? _database;

  static const _dbName = 'copypaster.db';
  static const _equipmentsTable = 'equipments';
  static const _servicesTable = 'services';
  static const _equipmentServicesTable = 'equipment_services';
  static const columnId = 'id';
  static const columnName = 'name';
  static const columnDescription = 'description';
  static const columnServiceId = 'id';
  static const columnServiceName = 'name';
  static const columnServiceDescription = 'description';
  static const columnEquipmentId = 'equipment_id';

  Future<Database> get database async {
    if (_database != null) return _database!;
    await _initDatabase();
    return _database!;
  }

  Future<void> _initDatabase() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    String path = join(await getDatabasesPath(), _dbName);
    _database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
      CREATE TABLE $_equipmentsTable (
        $columnId INTEGER PRIMARY KEY,
        $columnName TEXT,
        $columnDescription TEXT
      )
    ''');
      await db.execute('''
      CREATE TABLE $_servicesTable (
        $columnServiceId INTEGER PRIMARY KEY,
        $columnServiceName TEXT,
        $columnServiceDescription TEXT
      )
    ''');
      await db.execute('''
      CREATE TABLE $_equipmentServicesTable (
        $columnEquipmentId INTEGER,
        $columnServiceId INTEGER,
        FOREIGN KEY ($columnEquipmentId) REFERENCES $_equipmentsTable($columnId),
        FOREIGN KEY ($columnServiceId) REFERENCES $_servicesTable($columnServiceId),
        PRIMARY KEY ($columnEquipmentId, $columnServiceId)
      )
    ''');
    });
  }

  Future<int> insertEquipment(Equipment equipment) async {
    final Database db = await database;
    return await db.insert(_equipmentsTable, equipment.toMap());
  }

  Future<int> insertService(Service service) async {
    final Database db = await database;
    return await db.insert(_servicesTable, service.toMap());
  }

  Future<int> insertEquipmentService(EquipmentService equipmentService) async {
    final Database db = await database;
    return await db.insert(_equipmentServicesTable, equipmentService.toMap());
  }

  Future<List<Equipment>> getAllEquipments() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_equipmentsTable);

    return List.generate(maps.length, (i) {
      return Equipment(
        id: maps[i][columnId],
        name: maps[i][columnName],
        description: maps[i][columnDescription],
      );
    });
  }

  Future<void> clearDatabase() async {
    final Database db = await database;
    await db.delete(_equipmentsTable);
    await db.delete(_servicesTable);
    await db.delete(_equipmentServicesTable);
  }
}
