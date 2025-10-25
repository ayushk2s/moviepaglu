import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'dart:ui_web' as ui;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class HowToDownloadPage extends StatefulWidget {
  @override
  State<HowToDownloadPage> createState() => _HowToDownloadPageState();
}

class _HowToDownloadPageState extends State<HowToDownloadPage> {
  final String embedUrl = 'https://voe.sx/e/ydws0cvmauxa';

  final List<Map<String, String>> steps = [
    {
      'title': 'Step 1',
      'description':
      'Click on the movie. You may be redirected to another page — if so, come back. Once the details are visible, scroll down.',
    },
    {
      'title': 'Step 2',
      'description':
      'At the bottom, you will see links with different resolutions. Tap on any of them.',
    },
    {
      'title': 'Step 3',
      'description':
      'You will be redirected to another page. Check the "I am not a robot" box and complete the verification. If redirected again, just return to the previous page.',
    },
    {
      'title': 'Step 4',
      'description':
      'Once verified, a URL generation process will begin. If you are redirected during this, return and continue until the process completes.',
    },
    {
      'title': 'Step 5',
      'description':
      'You will land on the HubCloud platform. Tap "Generate Link". You may be redirected once or twice — come back each time. Finally, you will reach the actual download page.',
    },
  ];

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      ui.platformViewRegistry.registerViewFactory(
        'voe-iframe',
            (int viewId) => html.IFrameElement()
          ..src = embedUrl
          ..style.border = 'none'
          ..allowFullscreen = true
          ..style.width = '100%'
          ..style.height = '100%',
      );
    }
  }

  Widget buildVideoPlayer() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: HtmlElementView(viewType: 'voe-iframe'),
    );
  }

  Widget buildStepsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: steps.map((step) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Card(
            color: Colors.grey[900],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step['title']!,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    step['description']!,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('How to Download', style: TextStyle(color: Colors.amber)),
        iconTheme: const IconThemeData(color: Colors.amber),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 1100;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: isWide
                ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Watch this tutorial:", style: TextStyle(color: Colors.amber, fontSize: 20)),
                      const SizedBox(height: 10),
                      buildVideoPlayer(),
                    ],
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Follow the steps below:", style: TextStyle(color: Colors.amber, fontSize: 20)),
                      const SizedBox(height: 10),
                      buildStepsList(),
                    ],
                  ),
                ),
              ],
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Watch this tutorial:", style: TextStyle(color: Colors.amber, fontSize: 20)),
                const SizedBox(height: 10),
                buildVideoPlayer(),
                const SizedBox(height: 30),
                const Text("Follow the steps below:", style: TextStyle(color: Colors.amber, fontSize: 20)),
                const SizedBox(height: 10),
                buildStepsList(),
              ],
            ),
          );
        },
      ),
    );
  }
}
