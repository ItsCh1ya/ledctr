import 'package:floor/floor.dart';
import 'package:ledctrl/domain/entity/module_info.dart';

class MatrixSizeConverter extends TypeConverter<MatrixSize, String> {
  @override
  MatrixSize decode(String databaseValue) {
    final parts = databaseValue.split(',');
    return MatrixSize(int.parse(parts[0]), int.parse(parts[1]));
  }

  @override
  String encode(MatrixSize value) {
    return '${value.width},${value.height}';
  }
}