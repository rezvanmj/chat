import 'dart:io';

import 'package:chat_project/domain/chat_room/file_path_model.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart' as prs;
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/chat_room/send_file_repository.dart';
import '../../domain/core/general_exceptions.dart';

class SendFileRepositoryImp extends SendFileRepository {
  final Dio dio;

  SendFileRepositoryImp(this.dio);
  @override
  Future<FilePathModel> sendFile(Map<String, File?> uploadingFile) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      Map<String, MultipartFile> data = {};

      final value = uploadingFile['chatFile']!;

      if (isImage(value.path)) {
        final multiFile = await fileToMultiPartFile(value, 'image');
        data.putIfAbsent('chatFile', () {
          return multiFile;
        });
      } else {
        final multiFile = await fileToMultiPartFile(value, 'application');
        data.putIfAbsent('chatFile', () {
          return multiFile;
        });
      }

      final response = await dio.post('/api/chat/admin/uploadImage/',
          data: FormData.fromMap(data),
          options: Options(headers: {'token': prefs.get('token')}));

      return FilePathModel.fromJson(response.data);
    } catch (e, s) {
      throw getGeneralException(e);
    }
  }

  bool isImage(String path) {
    final mimeType = lookupMimeType(path);

    return mimeType!.startsWith('image/');
  }

  Future<MultipartFile> fileToMultiPartFile(File file, String type) async {
    return await MultipartFile.fromFile(
      file.path,
      filename: file.path.split('/').last,
      contentType: prs.MediaType(type, file.path.split(".").last),
    );
  }
}
