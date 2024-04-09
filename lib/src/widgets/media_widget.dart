import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:sportconnect/src/models/media.dart' as sc;
import 'package:sportconnect/main.dart';

class MediaWidget extends StatefulWidget {
  final RxList<sc.Media> mediaList;
  final int eventId;
  final void Function() refreshEventInfo;

  const MediaWidget({
    Key? key,
    required this.mediaList,
    required this.eventId,
    required this.refreshEventInfo,
  }) : super(key: key);

  @override
  _MediaWidgetState createState() => _MediaWidgetState();
}

class _MediaWidgetState extends State<MediaWidget> {
  late final List<Player> _videoPlayers = [];
  late final List<VideoController> _videoControllers = [];
  sc.MediaType? selectedMediaType;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    MediaKit.ensureInitialized();
    _initializeMedia();
    widget.mediaList.listen((_) {
      _initializeMedia();
    });
  }

  void _initializeMedia() {
    for (var player in _videoPlayers) {
      player.dispose();
    }
    _videoPlayers.clear();
    _videoControllers.clear();

    for (var media in widget.mediaList) {
      if (media.type == sc.MediaType.video) {
        Player player = Player();
        VideoController controller = VideoController(player);
        player.open(Media(media.path));
        _videoPlayers.add(player);
        _videoControllers.add(controller);
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    for (var player in _videoPlayers) {
      player.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var filteredMediaList = selectedMediaType == null
          ? widget.mediaList
          : widget.mediaList
              .where((media) => media.type == selectedMediaType)
              .toList();
      int videoIndex = -1;

      if (widget.mediaList.isEmpty) {
        return const Center(child: Text('No media available.'));
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.image),
                onPressed: () =>
                    setState(() => selectedMediaType = sc.MediaType.image),
              ),
              IconButton(
                icon: const Icon(Icons.videocam),
                onPressed: () =>
                    setState(() => selectedMediaType = sc.MediaType.video),
              ),
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => setState(() => selectedMediaType = null),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                icon: Icon(Icons.image),
                label: Text("Upload Image"),
                onPressed: () => _pickMedia('image'),
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.video_call),
                label: Text("Upload Video"),
                onPressed: () => _pickMedia('video'),
              ),
            ],
          ),
          const Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('SportConnect highlights'),
            ),
          ),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filteredMediaList.length,
              itemBuilder: (context, index) {
                final media = filteredMediaList[index];

                const mediaWidth = 300.0;
                const mediaHeight = 200.0;

                Widget mediaWidget;
                if (media.type == sc.MediaType.image) {
                  mediaWidget = Image.network(media.path, fit: BoxFit.cover);
                } else if (media.type == sc.MediaType.video &&
                    videoIndex + 1 < _videoControllers.length) {
                  videoIndex++;
                  mediaWidget =
                      Video(controller: _videoControllers[videoIndex]);
                } else {
                  mediaWidget = const SizedBox.shrink();
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: SizedBox(
                    width: mediaWidth,
                    height: mediaHeight,
                    child: ClipRRect(
                      child: mediaWidget,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }

  Future<void> _pickMedia(String mediaType) async {
    XFile? pickedFile;

    if (mediaType == 'image') {
      pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
    } else if (mediaType == 'video') {
      pickedFile = await _picker.pickVideo(
        source: ImageSource.gallery,
      );
    }

    if (pickedFile != null) {
      uploadEventMedia(widget.eventId, pickedFile.path, mediaType);
      widget.refreshEventInfo();
    }
  }
}

Future<void> uploadEventMedia(
    int idEvent, String mediaPath, String mediaType) async {
  try {
    final fileExt = mediaPath.split('.').last;
    final filePath = 'events/${DateTime.now().toIso8601String()}.$fileExt';
    final fileBytes = await File(mediaPath).readAsBytes();

    await supabase.storage
        .from('sportconnect')
        .uploadBinary(filePath, fileBytes);

    final imageUrlResponse = await supabase.storage
        .from('sportconnect')
        .createSignedUrl(filePath, 60 * 60 * 24 * 365 * 10);

    final insertResponse = await supabase.from('events_media').insert({
      'media_path': imageUrlResponse,
      'media_type': mediaType,
      'id_event': idEvent,
    });

    if (insertResponse.error != null) {
      throw Exception(
          'Failed to insert media info: ${insertResponse.error?.message}');
    }

    print('Media uploaded and info inserted successfully');
  } catch (e) {
    print('An error occurred: $e');
  }
}
