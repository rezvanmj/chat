import 'dart:io';

import 'file_path_model.dart';

abstract class SendFileRepository {
  Future<FilePathModel> sendFile(Map<String, File?> uploadingFile);
}
