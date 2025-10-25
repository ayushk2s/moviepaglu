import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoLinkPlayer extends StatefulWidget {
  const VideoLinkPlayer({super.key});

  @override
  State<VideoLinkPlayer> createState() => _VideoLinkPlayerState();
}

class _VideoLinkPlayerState extends State<VideoLinkPlayer> {
  VideoPlayerController? controller;
  final TextEditingController urlController = TextEditingController();
  bool isPlaying = false;
  double volume = 1.0;
  bool isFullscreen = false;
  bool isLoading = false;

  void playVideo(String videoUrl) {
    setState(() {
      isLoading = true;
    });

    controller?.dispose();
    controller = VideoPlayerController.network(videoUrl)
      ..initialize().then((_) {
        controller!.addListener(() {
          if (mounted) setState(() {});
        });

        setState(() {
          isLoading = false;
          controller?.play();
          controller?.setVolume(volume);
          isPlaying = true;
        });
      }).catchError((error) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error loading video: $error")),
        );
      });
  }

  void togglePlayPause() {
    if (controller != null && controller!.value.isInitialized) {
      setState(() {
        if (controller!.value.isPlaying) {
          controller!.pause();
          isPlaying = false;
        } else {
          controller!.play();
          isPlaying = true;
        }
      });
    }
  }

  void seekForward() {
    if (controller != null && controller!.value.isInitialized) {
      final currentPosition = controller!.value.position;
      final duration = controller!.value.duration;
      final newPosition = currentPosition + const Duration(seconds: 10);
      controller!.seekTo(newPosition < duration ? newPosition : duration);
    }
  }

  void seekBackward() {
    if (controller != null && controller!.value.isInitialized) {
      final currentPosition = controller!.value.position;
      final newPosition = currentPosition - const Duration(seconds: 10);
      controller!.seekTo(newPosition > Duration.zero ? newPosition : Duration.zero);
    }
  }

  void toggleFullscreen() {
    setState(() {
      isFullscreen = !isFullscreen;
    });
  }

  String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);
    return hours > 0
        ? '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}'
        : '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }

  @override
  void dispose() {
    controller?.dispose();
    urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Paste Video URL")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: urlController,
              decoration: const InputDecoration(
                labelText: "Paste video URL here",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final inputUrl = urlController.text.trim();
                if (inputUrl.isNotEmpty) {
                  playVideo(inputUrl);
                }
              },
              child: const Text("Play Video"),
            ),
            const SizedBox(height: 20),

            // Video section
            if (isLoading)
              const CircularProgressIndicator()
            else if (controller != null && controller!.value.isInitialized)
              Column(
                children: [
                  Container(
                    width: isFullscreen
                        ? mediaQuery.size.width
                        : mediaQuery.size.width * 0.9,
                    height: isFullscreen
                        ? mediaQuery.size.height * 0.7
                        : null,
                    child: AspectRatio(
                      aspectRatio: controller!.value.aspectRatio,
                      child: VideoPlayer(controller!),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Seek bar
                  Slider(
                    value: controller!.value.position.inMilliseconds.toDouble(),
                    min: 0.0,
                    max: controller!.value.duration.inMilliseconds.toDouble(),
                    onChanged: (value) {
                      controller!.seekTo(Duration(milliseconds: value.toInt()));
                    },
                  ),

                  // Time display
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        formatDuration(controller!.value.position),
                        style: const TextStyle(fontSize: 12),
                      ),
                      const Text(" / "),
                      Text(
                        formatDuration(controller!.value.duration),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Controls
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.replay_10),
                        onPressed: seekBackward,
                      ),
                      IconButton(
                        icon: Icon(isPlaying
                            ? Icons.pause
                            : Icons.play_arrow),
                        onPressed: togglePlayPause,
                      ),
                      IconButton(
                        icon: const Icon(Icons.forward_10),
                        onPressed: seekForward,
                      ),
                      IconButton(
                        icon: const Icon(Icons.fullscreen),
                        onPressed: toggleFullscreen,
                      ),
                    ],
                  ),

                  // Volume slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.volume_up),
                      Slider(
                        value: volume,
                        min: 0,
                        max: 1,
                        onChanged: (val) {
                          setState(() {
                            volume = val;
                            controller?.setVolume(volume);
                          });
                        },
                      ),
                    ],
                  ),
                ],
              )
            else if (controller != null)
                const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
