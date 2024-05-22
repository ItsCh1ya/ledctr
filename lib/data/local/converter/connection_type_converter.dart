import 'package:floor/floor.dart';
import 'package:ledctrl/domain/entity/module_info.dart';

class ConnectionTypeConverter extends TypeConverter<ConnectionType, String> {
  @override
  ConnectionType decode(String databaseValue) {
    return ConnectionType.values.firstWhere((e) => e.toString() == databaseValue);
  }

  @override
  String encode(ConnectionType value) {
    return value.toString();
  }
}