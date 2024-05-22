// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  ModuleInfoDao? _moduleInfoDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `module_info` (`name` TEXT NOT NULL, `description` TEXT NOT NULL, `version` TEXT NOT NULL, `author` TEXT NOT NULL, `colorDeph` INTEGER NOT NULL, `size` TEXT NOT NULL, `connection` TEXT NOT NULL, `path` TEXT NOT NULL, PRIMARY KEY (`name`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ModuleInfoDao get moduleInfoDao {
    return _moduleInfoDaoInstance ??= _$ModuleInfoDao(database, changeListener);
  }
}

class _$ModuleInfoDao extends ModuleInfoDao {
  _$ModuleInfoDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _moduleInfoInsertionAdapter = InsertionAdapter(
            database,
            'module_info',
            (ModuleInfo item) => <String, Object?>{
                  'name': item.name,
                  'description': item.description,
                  'version': item.version,
                  'author': item.author,
                  'colorDeph': item.colorDeph,
                  'size': _matrixSizeConverter.encode(item.size),
                  'connection':
                      _connectionTypeConverter.encode(item.connection),
                  'path': item.path
                }),
        _moduleInfoUpdateAdapter = UpdateAdapter(
            database,
            'module_info',
            ['name'],
            (ModuleInfo item) => <String, Object?>{
                  'name': item.name,
                  'description': item.description,
                  'version': item.version,
                  'author': item.author,
                  'colorDeph': item.colorDeph,
                  'size': _matrixSizeConverter.encode(item.size),
                  'connection':
                      _connectionTypeConverter.encode(item.connection),
                  'path': item.path
                }),
        _moduleInfoDeletionAdapter = DeletionAdapter(
            database,
            'module_info',
            ['name'],
            (ModuleInfo item) => <String, Object?>{
                  'name': item.name,
                  'description': item.description,
                  'version': item.version,
                  'author': item.author,
                  'colorDeph': item.colorDeph,
                  'size': _matrixSizeConverter.encode(item.size),
                  'connection':
                      _connectionTypeConverter.encode(item.connection),
                  'path': item.path
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ModuleInfo> _moduleInfoInsertionAdapter;

  final UpdateAdapter<ModuleInfo> _moduleInfoUpdateAdapter;

  final DeletionAdapter<ModuleInfo> _moduleInfoDeletionAdapter;

  @override
  Future<List<ModuleInfo>> findAllModules() async {
    return _queryAdapter.queryList('SELECT * FROM module_info',
        mapper: (Map<String, Object?> row) => ModuleInfo(
            name: row['name'] as String,
            description: row['description'] as String,
            version: row['version'] as String,
            author: row['author'] as String,
            colorDeph: row['colorDeph'] as int,
            size: _matrixSizeConverter.decode(row['size'] as String),
            connection:
                _connectionTypeConverter.decode(row['connection'] as String),
            path: row['path'] as String));
  }

  @override
  Future<ModuleInfo?> findModuleByName(String name) async {
    return _queryAdapter.query('SELECT * FROM module_info WHERE name = ?1',
        mapper: (Map<String, Object?> row) => ModuleInfo(
            name: row['name'] as String,
            description: row['description'] as String,
            version: row['version'] as String,
            author: row['author'] as String,
            colorDeph: row['colorDeph'] as int,
            size: _matrixSizeConverter.decode(row['size'] as String),
            connection:
                _connectionTypeConverter.decode(row['connection'] as String),
            path: row['path'] as String),
        arguments: [name]);
  }

  @override
  Future<void> insertModule(ModuleInfo module) async {
    await _moduleInfoInsertionAdapter.insert(module, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateModule(ModuleInfo module) async {
    await _moduleInfoUpdateAdapter.update(module, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteModule(ModuleInfo module) async {
    await _moduleInfoDeletionAdapter.delete(module);
  }
}

// ignore_for_file: unused_element
final _matrixSizeConverter = MatrixSizeConverter();
final _connectionTypeConverter = ConnectionTypeConverter();
