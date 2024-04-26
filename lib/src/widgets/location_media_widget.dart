import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:sportconnect/src/models/media.dart' as sc;
import 'package:sportconnect/main.dart';

class LocationMediaWidget extends StatefulWidget {
  final RxList<sc.Media> mediaList;
  final int locationId;
  final String locationName;
  final void Function() refreshLocationInfo;

  const LocationMediaWidget({
    super.key,
    required this.mediaList,
    required this.locationId,
    required this.locationName,
    required this.refreshLocationInfo,
  });

  @override
  MediaWidgetState createState() => MediaWidgetState();
}

class MediaWidgetState extends State<LocationMediaWidget> {
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
        player.open(Media(media.path), play: false);
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

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${widget.locationName} Gallery',
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 200,
            child: filteredMediaList.isNotEmpty
                ? ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: filteredMediaList.length,
                    itemBuilder: (context, index) {
                      final media = filteredMediaList[index];
                      return GestureDetector(
                        onTap: () => _viewMedia(media),
                        child: _buildMediaItem(media),
                      );
                    },
                  )
                : const Center(child: Text('No media available.')),
          ),
          _buildMediaControlButtons(),
        ],
      );
    });
  }

  void _viewMedia(sc.Media media) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: media.type == sc.MediaType.image
            ? Image.network(media.path)
            : Video(controller: _videoControllers.first),
      ),
    );
  }

  Widget _buildMediaControlButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        spacing: 4.0,
        runSpacing: 4.0,
        children: [
          IconButton(
            icon: const Icon(Icons.image, size: 20),
            onPressed: () =>
                setState(() => selectedMediaType = sc.MediaType.image),
            padding: const EdgeInsets.all(4.0),
          ),
          IconButton(
            icon: const Icon(Icons.videocam, size: 20),
            onPressed: () =>
                setState(() => selectedMediaType = sc.MediaType.video),
            padding: const EdgeInsets.all(4.0),
          ),
          IconButton(
            icon: const Icon(Icons.clear, size: 20),
            onPressed: () => setState(() => selectedMediaType = null),
            padding: const EdgeInsets.all(4.0),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaItem(sc.Media media) {
    const mediaWidth = 320.0;
    const mediaHeight = 180.0;

    Widget mediaWidget;

    if (media.type == sc.MediaType.image) {
      mediaWidget = Image.network(media.path, fit: BoxFit.cover);
    } else if (media.type == sc.MediaType.video) {
      mediaWidget = Video(
        controller: _videoControllers.isNotEmpty
            ? _videoControllers[0]
            : VideoController(Player()),
      );
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
      uploadEventMedia(widget.locationId, pickedFile.path, mediaType);
      widget.refreshLocationInfo();
    }
  }
}

Future<void> uploadEventMedia(
    int idLocation, String mediaPath, String mediaType) async {
  try {
    final fileExt = mediaPath.split('.').last;
    final filePath = 'locations/${DateTime.now().toIso8601String()}.$fileExt';
    final fileBytes = await File(mediaPath).readAsBytes();

    await supabase.storage
        .from('sportconnect')
        .uploadBinary(filePath, fileBytes);

    final imageUrlResponse = await supabase.storage
        .from('sportconnect')
        .createSignedUrl(filePath, 60 * 60 * 24 * 365 * 10);

    final insertResponse = await supabase.from('locations_media').insert({
      'media_path': imageUrlResponse,
      'media_type': mediaType,
      'location_id': idLocation,
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
