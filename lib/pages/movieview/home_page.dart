import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_paglu/pages/linkyshare/linkyshare_video.dart';
import 'package:movie_paglu/pages/top_three_page/download_way.dart';
import 'package:movie_paglu/pages/movieview/movie_detail_page.dart';
import 'package:movie_paglu/pages/top_three_page/upload_and_earn.dart';
import 'dart:js' as js;


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> movies = [];
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  String selectedGenre = '';

  final List<String> genres = [
    'Action', 'Adventure', 'Comedy', 'Crime', 'Drama', 'Fantasy',
    'Horror', 'Mystery', 'Romance', 'Sci-Fi', 'Thriller',
    'Animation', 'Biography', 'Documentary'
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('movies').get();
      final movieList = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      setState(() {
        movies = movieList;
      });
    } catch (e) {
      print("Error fetching movies: $e");
    }
  }

  List<Map<String, dynamic>> getFilteredMovies() {
    if (searchQuery.isEmpty && selectedGenre.isEmpty) return movies;

    final List<Map<String, dynamic>> titleMatches = [];
    final List<Map<String, dynamic>> genreMatches = [];
    final List<Map<String, dynamic>> descriptionMatches = [];

    for (var movie in movies) {
      final title = (movie['title'] ?? '').toString().toLowerCase();
      final description = (movie['description'] ?? '').toString().toLowerCase();
      final rawGenres = movie['genres'] ?? [];
      final genresList = rawGenres is List
          ? rawGenres.map((g) => g.toString().toLowerCase()).toList()
          : [];

      final genreMatch = selectedGenre.isNotEmpty &&
          genresList.any((g) => g.contains(selectedGenre.toLowerCase()));

      if (selectedGenre.isNotEmpty && !genreMatch) continue;

      if (title.contains(searchQuery)) {
        titleMatches.add(movie);
      } else if (genresList.any((g) => g.contains(searchQuery))) {
        genreMatches.add(movie);
      } else if (description.contains(searchQuery)) {
        descriptionMatches.add(movie);
      }
    }

    return [...titleMatches, ...genreMatches, ...descriptionMatches];
  }

  Widget buildMovieCard(String imageUrl, String title, String quality, Map<String, dynamic> fullData) {
    return GestureDetector(
      onTap: () {
        js.context.callMethod('runPopAdsScript');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MovieDetailPage(movie: fullData),
          ),
        );
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
                      imageUrl,
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
                      SizedBox(height: 4),
                      Text(
                        quality,
                        style: TextStyle(color: Colors.grey, fontSize: 11),
                      )
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

    final filteredMovies = getFilteredMovies();

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
                        '🎬 Movie Paglu',
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
                        '🎬 Movie Paglu',
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
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Wrap(
                spacing: 16,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (cotext) => LinkShareVideo()));
                    },
                    child: Text('18+ Adult', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => UploadAndEarnPage()));
                    },
                    child: Text('Upload & Earn', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => HowToDownloadPage()));
                    },
                    child: Text('How to Download', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
                  ),
                ],
              ),
            ),
          ),
          if(_searchController.text.trim().isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: genres.map((label) {
                    final isSelected = selectedGenre == label;
                    return ChoiceChip(
                      label: Text(label),
                      labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      selected: isSelected,
                      selectedColor: Colors.amber,
                      backgroundColor: Colors.redAccent,
                      onSelected: (_) {
                        setState(() {
                          selectedGenre = isSelected ? '' : label;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
          if (filteredMovies.isEmpty)
            SliverFillRemaining(
              child: Center(child: CircularProgressIndicator(color: Colors.amber)),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(8.0),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final movie = filteredMovies[index];
                    final imageUrl = movie['posterUrl'] ?? '';
                    final title = movie['title'] ?? '';
                    final links = movie['links'] as Map<String, dynamic>? ?? {};
                    final resolutionText = links.keys.join(' | ');
                    return buildMovieCard(imageUrl, title, resolutionText, movie);
                  },
                  childCount: filteredMovies.length,
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
