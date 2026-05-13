import '../models/uploaded_driver_photo.dart';
import 'api_client.dart';
import 'api_config.dart';

class UploadService {
  UploadService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<UploadedDriverPhoto> uploadDriverPhoto(String filePath) async {
    final response = await _apiClient.multipartPost(
      ApiConfig.uploadDriverPhoto,
      fileField: 'photo',
      filePath: filePath,
    );

    if (response is Map<String, dynamic>) {
      final file = response['file'];
      if (file is Map<String, dynamic>) {
        return UploadedDriverPhoto.fromJson(file);
      }
    }

    throw Exception('Photo upload failed. Please try again.');
  }
}
