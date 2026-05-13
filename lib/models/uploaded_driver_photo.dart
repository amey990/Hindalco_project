class UploadedDriverPhoto {
  const UploadedDriverPhoto({
    required this.originalName,
    required this.mimeType,
    required this.size,
    required this.s3Bucket,
    required this.s3Key,
    required this.previewUrl,
    required this.previewUrlExpiresInSeconds,
  });

  final String originalName;
  final String mimeType;
  final int size;
  final String s3Bucket;
  final String s3Key;
  final String previewUrl;
  final int previewUrlExpiresInSeconds;

  factory UploadedDriverPhoto.fromJson(Map<String, dynamic> json) {
    return UploadedDriverPhoto(
      originalName: json['original_name']?.toString() ?? '',
      mimeType: json['mime_type']?.toString() ?? '',
      size: _parseInt(json['size']),
      s3Bucket: json['s3_bucket']?.toString() ?? '',
      s3Key: json['s3_key']?.toString() ?? '',
      previewUrl: json['preview_url']?.toString() ?? '',
      previewUrlExpiresInSeconds: _parseInt(
        json['preview_url_expires_in_seconds'],
      ),
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
