import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;
  final bool autoPlay;
  final bool looping;
  final bool showControls;

  const VideoPlayerWidget({
    Key? key,
    required this.videoPath,
    this.autoPlay = true,
    this.looping = false,
    this.showControls = true,
  }) : super(key: key);

  @override
  State<VideoPlayerWidget> createState() => _CloudinaryVideoPlayerState();
}

class _CloudinaryVideoPlayerState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    // Add Cloudinary optimization parameters
    final optimizedUrl = '${widget.videoPath}?fm=mp4&q=70&f=auto';

    _videoController = VideoPlayerController.network(optimizedUrl);

    try {
      await _videoController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoController,
        autoPlay: widget.autoPlay,
        looping: widget.looping,
        showControls: widget.showControls,
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.blue,
          handleColor: Colors.blueAccent,
          backgroundColor: Colors.grey,
          bufferedColor: Colors.grey[300]!,
        ),
        placeholder: Container(
          color: Colors.black,
          child: const Center(child: CircularProgressIndicator()),
        ),
        autoInitialize: true,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
        // Customize controls appearance
        customControls: const CupertinoControls(
          backgroundColor: Color.fromRGBO(0, 0, 0, 0.7),
          iconColor: Colors.white,
        ),
      );

      setState(() => _isInitializing = false);
    } catch (e) {
      debugPrint('Video initialization error: $e');
      setState(() => _isInitializing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return Container(
        color: Colors.black,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_chewieController == null) {
      return Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.white, size: 50),
              const SizedBox(height: 16),
              const Text('Failed to load video',
                  style: TextStyle(color: Colors.white)),
              TextButton(
                onPressed: _initializePlayer,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: _videoController.value.aspectRatio,
      child: Chewie(controller: _chewieController!),
    );
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
}