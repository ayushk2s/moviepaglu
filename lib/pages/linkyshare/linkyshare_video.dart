import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:html' as html;

class LinkShareVideo extends StatefulWidget {
  @override
  _LinkShareVideoState createState() => _LinkShareVideoState();
}

class _LinkShareVideoState extends State<LinkShareVideo> {
  List<Map<String, dynamic>> videos = [];
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
    fetchVideos();
  }

  Future<void> fetchVideos() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('linkyshare').get();
      final videoList = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      setState(() {
        videos = videoList;
      });
    } catch (e) {
      print("Error fetching videos: $e");
    }
  }

  List<Map<String, dynamic>> getFilteredVideos() {
    if (searchQuery.isEmpty) return videos;

    return videos.where((video) {
      final title = (video['title'] ?? '').toString().toLowerCase();
      return title.contains(searchQuery);
    }).toList();
  }

  Widget buildVideoCard(String imageUrl, String title, String videoUrl) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(12),
              ),
              child: CircularProgressIndicator(color: Colors.amber),
            ),
          ),
        );

        final script = html.ScriptElement()
          ..type = 'text/javascript'
          ..src = 'https://groleegni.net/401/9504303';
        html.document.body?.append(script);

        Future.delayed(Duration(seconds: 4), () {
          Navigator.of(context).pop();
          html.window.open(videoUrl, '_blank');
        });
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          double imageHeight = constraints.maxHeight * 0.75;
          double textHeight = constraints.maxHeight * 0.2;

          return Container(
            margin: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: Colors.amber, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: imageHeight,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(6)),
                    child: Image.network(
                      'https://floral-mode-4a3e.ayushpandey85986.workers.dev/?url=${Uri.encodeComponent(imageUrl)}',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Center(child: Icon(Icons.broken_image, color: Colors.white)),
                    ),
                  ),
                ),
                Container(
                  height: textHeight,
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    int crossAxisCount = width > 1200 ? 6 : width > 1000 ? 5 : width > 800 ? 4 : width > 600 ? 3 : 2;

    final filteredVideos = getFilteredVideos();

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: LayoutBuilder(
              builder: (context, constraints) {
                bool isWide = constraints.maxWidth > 700;
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: isWide
                      ? Row(
                    children: [
                      Text(
                        '📦 18+ Videos',
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.amber),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[800],
                            hintText: 'Search...',
                            hintStyle: TextStyle(color: Colors.white54),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: Icon(Icons.search, color: Colors.white54),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  )
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '📦 LinkyShare Videos',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.amber),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: _searchController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[800],
                          hintText: 'Search...',
                          hintStyle: TextStyle(color: Colors.white54),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: Icon(Icons.search, color: Colors.white54),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (filteredVideos.isEmpty)
            SliverFillRemaining(
              child: Center(child: CircularProgressIndicator(color: Colors.amber)),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(8.0),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final video = filteredVideos[index];
                    final thumbnailUrl = video['thumbnailUrl'] ?? '';
                    final title = video['title'] ?? '';
                    return buildVideoCard(thumbnailUrl, title, video['link'] ?? '');
                  },
                  childCount: filteredVideos.length,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 0.6,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
