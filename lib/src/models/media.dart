enum MediaType { video, image }

class Media {
  final String path;
  final MediaType type;

  Media({required this.path, required this.type});
}
