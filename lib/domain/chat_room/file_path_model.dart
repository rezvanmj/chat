class FilePathModel {
  final String fileName;
  final String filePath;

  FilePathModel({required this.fileName, required this.filePath});

  factory FilePathModel.fromJson(Map<String, dynamic> data) {
    return FilePathModel(fileName: data['name'], filePath: data['path']);
  }
}
