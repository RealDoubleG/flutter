// ignore: file_names
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:text_copypaster/models/Equipment.dart';
import 'package:text_copypaster/models/equipmentService.dart';
import 'package:text_copypaster/models/service.dart';
import 'package:text_copypaster/widgets/modals/serviceRegister/editService.dart';

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
        $columnServiceDescription TEXT,
        $columnEquipmentId INTEGER,
        FOREIGN KEY ($columnEquipmentId) REFERENCES $_equipmentsTable($columnId)
  )
''');
    });
  }

  Future<void> resetDatabase() async {
    final Database db = await database;
    await db.execute('DROP TABLE IF EXISTS $_equipmentServicesTable');
    await db.execute('DROP TABLE IF EXISTS $_servicesTable');
    await db.execute('DROP TABLE IF EXISTS $_equipmentsTable');

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
      $columnServiceDescription TEXT,
      $columnEquipmentId INTEGER,
      FOREIGN KEY ($columnEquipmentId) REFERENCES $_equipmentsTable($columnId)
    )
  ''');
  }

  Future<List<Equipment>> getEquipmentsByName(String name) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _equipmentsTable,
      where: '$columnName LIKE ?',
      whereArgs: ['%$name%'],
    );

    return List.generate(maps.length, (i) {
      return Equipment(
        id: maps[i][columnId],
        name: maps[i][columnName],
        description: maps[i][columnDescription],
      );
    });
  }

  Future<void> exportDatabase() async {
    String appDocDir = await getDatabasesPath();
    String dbPath = join(appDocDir, _dbName);
    File dbFile = File(dbPath);

    try {
      String? exportPath = await FilePicker.platform.saveFile(
        allowedExtensions: ['db'],
        fileName: _dbName,
      );

      if (exportPath == null) return;

      File exportFile = File(exportPath);

      if (await exportFile.exists()) {
        String newFileName =
            '$_dbName-${DateTime.now().millisecondsSinceEpoch}.db';
        exportPath = join(dirname(exportPath), newFileName);
        exportFile = File(exportPath);
      }

      await dbFile.copy(exportPath);
    } catch (e) {
      print(e);
    }
  }

  Future<void> importDatabase() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['db'],
      );

      if (result == null) return;

      String? importPath = result.files.single.path;

      String appDocDir = await getDatabasesPath();
      String dbPath = '$appDocDir/$_dbName';

      Database importedDatabase = await openDatabase(importPath!);

      List<Map<String, dynamic>> equipmentsData =
          await importedDatabase.query(_equipmentsTable);

      List<Map<String, dynamic>> servicesData =
          await importedDatabase.query(_servicesTable);

      final Database db = await database;

      await db.transaction((txn) async {
        for (Map<String, dynamic> equipment in equipmentsData) {
          int result = await txn.insert(_equipmentsTable, equipment,
              conflictAlgorithm: ConflictAlgorithm.replace);
          if (result == -1) {
            await txn.update(_equipmentsTable, equipment,
                where: '$columnId = ?', whereArgs: [equipment[columnId]]);
          }
        }

        for (Map<String, dynamic> service in servicesData) {
          int result = await txn.insert(_servicesTable, service,
              conflictAlgorithm: ConflictAlgorithm.replace);
          if (result == -1) {
            await txn.update(_servicesTable, service,
                where: '$columnServiceId = ?',
                whereArgs: [service[columnServiceId]]);
          }
        }
      });
    } catch (e) {
      print('Erro ao importar banco de dados: $e');
    }
  }

  Future<List<Service>> getServicesByEquipmentId(int equipmentId) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _servicesTable,
      where: '$columnEquipmentId = ?',
      whereArgs: [equipmentId],
    );

    return List.generate(maps.length, (i) {
      return Service(
        id: maps[i][columnServiceId],
        name: maps[i][columnServiceName],
        description: maps[i][columnServiceDescription],
        equipmentId: maps[i][columnEquipmentId],
      );
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

  Future<void> editServiceById(Service service) async {
    final Database db = await database;
    await db.update(
      _servicesTable,
      service.toMap(),
      where: '$columnId = ?',
      whereArgs: [service.id],
    );
  }

  Future<void> editEquipmentById(Equipment equipment) async {
    final Database db = await database;
    await db.update(
      _equipmentsTable,
      equipment.toMap(),
      where: '$columnId = ?',
      whereArgs: [equipment.id],
    );
  }

  Future<int> insertEquipmentService(EquipmentService equipmentService) async {
    final Database db = await database;
    return await db.insert(_equipmentServicesTable, equipmentService.toMap());
  }

  Future<void> deleteEquipmentByid(int id) async {
    final Database db = await database;
    await db.delete(
      _equipmentsTable,
      where: '$columnId = ?',
      whereArgs: [id],
    );

    await db.delete(
      _servicesTable,
      where: '$columnEquipmentId = ?',
      whereArgs: [id],
    );
  }

  Future<bool> equipmentExists(int id) async {
    final Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      _equipmentsTable,
      where: '$columnId = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty;
  }

  Future<void> deleteServiceById(int id) async {
    final Database db = await database;
    await db.delete(
      _servicesTable,
      where: '$columnServiceId = ?',
      whereArgs: [id],
    );
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
  }
}
