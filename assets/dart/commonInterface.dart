class ModuleInfo {
  final String name;
  final String description;
  final String version;
  final String author;
  final int colorDeph;
  final MatrixSize size;
  final String path;
  final String connection;
  const ModuleInfo({required this.name, required this.description, required this.version, required this.author, required this.colorDeph, required this.size, required this.connection, required this.path});
}

class MatrixSize {
  final int width;
  final int height;
  const MatrixSize(this.width, this.height);
}

enum ConnectionType {
  wifi, bluetooth, serial
}