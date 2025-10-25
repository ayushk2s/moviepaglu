import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:movie_paglu/ads/monetag_ad_banner.dart';
import 'package:movie_paglu/ads/interstitial_ads_monetag.dart';
import 'dart:html' as html;
import 'dart:async';

class MovieDetailPage extends StatelessWidget {
  final Map<String, dynamic> movie;

  const MovieDetailPage({Key? key, required this.movie}) : super(key: key);

  void _launchURL(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = movie['posterUrl'] ?? '';
    final title = movie['title'] ?? 'Untitled';
    final description = movie['description'] ?? 'No description available';
    final links = movie['links'] as Map<String, dynamic>? ?? {};
    final genres = (movie['genres'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .join(', ') ??
        'Unknown';
    final screenshots = movie['screenshots'] as List<dynamic>? ?? [];

    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text(title, style: TextStyle(color: Colors.amber)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Poster
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl,
                      height: isDesktop ? 450 : 300,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => Icon(Icons.broken_image, color: Colors.white, size: 80),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Center(
                  child: Text(
                    'Download Link 🡇',
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: isDesktop ? 30 : 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const MonetagAdBanner(),
                // Here ads
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: isDesktop ? 30 : 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                // Genres
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: genres.split(',').map((genre) {
                    return Chip(
                      label: Text(genre.trim(), style: TextStyle(color: Colors.white)),
                      backgroundColor: Colors.deepPurple,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Description
                Text("📝 Description", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 6),
                Text(description, style: TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 24),

                // Screenshots
                if (screenshots.isNotEmpty) ...[
                  Text("📷 Screenshots", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: screenshots.map((url) {
                        return Container(
                          margin: const EdgeInsets.only(right: 12),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              url,
                              height: 150,
                              errorBuilder: (ctx, err, stack) => Icon(Icons.image, color: Colors.white),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Download Links
                Text("⬇️ Download Links", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 10),
                ...links.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.download, color: Colors.black),
                      label: Text('${entry.key} - Download', style: TextStyle(color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        minimumSize: Size(double.infinity, 48),
                      ),
                      onPressed: () {
                        // Show a loading dialog
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

                        // Inject ad script
                        final script = html.ScriptElement()
                          ..type = 'text/javascript'
                          ..src = 'https://groleegni.net/401/9504303';

                        html.document.body?.append(script);

                        // Wait 4 seconds, then redirect
                        Future.delayed(Duration(seconds: 4), () {
                          Navigator.of(context).pop(); // Dismiss loading dialog
                          html.window.open(entry.value.toString(), '_blank'); // Open in new ta
                        });
                      },

                    ),
                  );
                }),

                const SizedBox(height: 32),

                // How to Download
                Text("❓ How to Download", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 6),
                Text(
                  "1. Click your preferred resolution above.\n"
                      "2. Complete the short link step (if any).\n"
                      "3. You’ll be redirected to your download page.",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
