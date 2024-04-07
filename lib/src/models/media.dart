enum MediaType { video, image }

class Media {
  final String path;
  final MediaType type;

  Media({required this.path, required this.type});

  factory Media.fromMap(Map<String, dynamic> map) {
    return Media(
      path: map['media_path'] as String,
      type: map['media_type'] == 'image' ? MediaType.image : MediaType.video,
    );
  }
}
