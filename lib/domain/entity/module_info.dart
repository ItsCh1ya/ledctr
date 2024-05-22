import 'package:floor/floor.dart';
import 'package:ledctrl/data/local/converter/connection_type_converter.dart';
import 'package:ledctrl/data/local/converter/matrix_size_converter.dart';

@Entity(tableName: 'module_info')
class ModuleInfo {
  @primaryKey
  final String name;
  final String description;
  final String version;
  final String author;
  final int colorDeph;
  @TypeConverters([MatrixSizeConverter])
  final MatrixSize size;
  @TypeConverters([ConnectionTypeConverter])
  final ConnectionType connection;
  final String path;

  const ModuleInfo({
    required this.name,
    required this.description,
    required this.version,
    required this.author,
    required this.colorDeph,
    required this.size,
    required this.connection,
    required this.path,
  });
}

class MatrixSize {
  final int width;
  final int height;
  const MatrixSize(this.width, this.height);
}

enum ConnectionType {
  wifi, bluetooth, serial
}

class SelectedModule {
  ModuleInfo? module;
  SelectedModule(this.module);
}