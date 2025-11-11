import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'db_today_task_entity.dart';

class TodayTaskDatabase extends GetxService {
  static Database? _database;

  static const String tableName = 'task';

  static const int _databaseVersion = 3;

  static const String _databaseName = 'today_task.db';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        duration INTEGER NOT NULL,
        description TEXT,
        image_path TEXT,
        color INTEGER NOT NULL,
        create_time TEXT NOT NULL,
        status TEXT NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE $tableName ADD COLUMN start_time TEXT');
      await db.execute('ALTER TABLE $tableName ADD COLUMN status TEXT');
      await db.execute('''
        UPDATE $tableName 
        SET start_time = create_time, 
            status = 'in_progress' 
        WHERE start_time IS NULL
      ''');
    }
    if (oldVersion < 3) {
      await db.execute('ALTER TABLE $tableName RENAME TO ${tableName}_old');
      await db.execute('''
        CREATE TABLE $tableName (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          duration INTEGER NOT NULL,
          description TEXT,
          image_path TEXT,
          color INTEGER NOT NULL,
          create_time TEXT NOT NULL,
          status TEXT NOT NULL
        )
      ''');
      await db.execute('''
        INSERT INTO $tableName (id, name, duration, description, image_path, color, create_time, status)
        SELECT id, name, duration, description, image_path, color, create_time, status
        FROM ${tableName}_old
      ''');
      await db.execute('DROP TABLE ${tableName}_old');
    }
  }

  Future<int> insertTask(TaskEntity task) async {
    try {
      final db = await database;
      return await db.insert(
        tableName,
        task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<TaskEntity>> getTasksByStatus(String status) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        tableName,
        where: 'status = ?',
        whereArgs: [status],
        orderBy: 'create_time DESC, id DESC',
      );
      return List.generate(maps.length, (i) {
        return TaskEntity.fromMap(maps[i]);
      });
    } catch (e) {
      return [];
    }
  }

  Future<int> updateTaskStatus(int id, String status) async {
    try {
      final db = await database;
      return await db.update(
        tableName,
        {'status': status},
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<TaskEntity?> getTaskById(int id) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
      if (maps.isEmpty) return null;
      return TaskEntity.fromMap(maps.first);
    } catch (e) {
      return null;
    }
  }

  Future<int> deleteAllTasks() async {
    try {
      final db = await database;
      return await db.delete(tableName);
    } catch (e) {
      rethrow;
    }
  }

  Future<TodayTaskDatabase> init() async {
    await database;
    return this;
  }
}
