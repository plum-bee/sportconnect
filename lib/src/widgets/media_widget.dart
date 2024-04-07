import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:sportconnect/src/models/media.dart';

class MediaWidget extends StatefulWidget {
  final List<Media> mediaList;
  final int eventId;

  const MediaWidget({Key? key, required this.mediaList, required this.eventId})
      : super(key: key);

  @override
  _MediaWidgetState createState() => _MediaWidgetState();
}

class _MediaWidgetState extends State<MediaWidget> {
  late List<VideoPlayerController> _videoControllers;
  late Map<int, GlobalKey> _playPauseButtonKeys;

  @override
  void initState() {
    super.initState();
    _videoControllers = [];
    _playPauseButtonKeys = {};
    _initializeVideoPlayers();
  }

  void _initializeVideoPlayers() {
    _videoControllers.clear();
    _playPauseButtonKeys.clear();

    for (int i = 0; i < widget.mediaList.length; i++) {
      var media = widget.mediaList[i];
      if (media.type == MediaType.video) {
        var controller =
            VideoPlayerController.networkUrl(Uri.parse(media.path));

        _videoControllers.add(controller);
      }
      _playPauseButtonKeys[i] = GlobalKey();
    }
  }

  @override
  void dispose() {
    for (var controller in _videoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mediaList.isEmpty) {
      return Center(child: Text('No images available.'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('SportConnect highlights',
                style: Theme.of(context).textTheme.subtitle1),
          ),
        ),
        Container(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.mediaList.length,
            itemBuilder: (context, index) {
              final media = widget.mediaList[index];
              if (media.type == MediaType.image) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child:
                      Image.network(media.path, fit: BoxFit.cover, height: 200),
                );
              } else if (media.type == MediaType.video) {
                VideoPlayerController controller = _videoControllers[0]
                  ..initialize().then((_) {
                    setState(() {});
                  });
                if (controller != null && controller.value.isInitialized) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        AspectRatio(
                          aspectRatio: controller.value.aspectRatio,
                          child: VideoPlayer(controller),
                        ),
                        FloatingActionButton(
                          key: _playPauseButtonKeys[
                              index], // Use index here instead of media.id
                          onPressed: () {
                            setState(() {
                              controller.value.isPlaying
                                  ? controller.pause()
                                  : controller.play();
                            });
                          },
                          child: Icon(
                            controller.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        ),
      ],
    );
  }
}
