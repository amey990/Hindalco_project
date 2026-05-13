import '../models/material_option.dart';
import 'api_client.dart';
import 'api_config.dart';

class MaterialService {
  MaterialService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<List<MaterialOption>> getMaterials() async {
    final response = await _apiClient.get(ApiConfig.materials);

    if (response is Map<String, dynamic>) {
      final materials = response['materials'];
      if (materials is List) {
        return materials
            .whereType<Map<String, dynamic>>()
            .map(MaterialOption.fromJson)
            .where((material) => material.name.trim().isNotEmpty)
            .toList();
      }
    }

    throw Exception('Unable to load materials.');
  }

  Future<MaterialOption> addMaterial(String name) async {
    final response = await _apiClient.post(
      ApiConfig.materials,
      body: {'name': name},
    );

    if (response is Map<String, dynamic>) {
      final material = response['material'];
      if (material is Map<String, dynamic>) {
        return MaterialOption.fromJson(material);
      }
    }

    throw Exception('Unable to save material.');
  }
}
