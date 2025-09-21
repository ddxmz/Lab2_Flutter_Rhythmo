import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MusicDetailPage extends StatefulWidget {
  final Map<String, dynamic> musicItem;

  const MusicDetailPage({
    super.key,
    required this.musicItem,
  });

  @override
  State<MusicDetailPage> createState() => _MusicDetailPageState();
}

class _MusicDetailPageState extends State<MusicDetailPage> {
  String? lyrics;
  bool isLoading = false;

  Future<void> fetchLyrics() async {
    if (widget.musicItem['browseId'] == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
            'https://youtube-music-api3.p.rapidapi.com/music/lyrics/plain?id=${widget.musicItem['browseId']}'),
        headers: {
          'x-rapidapi-key':
              '411aa8bf9cmsh79fcb792026c5edp175bdbjsn4535995e6b4e',
          'x-rapidapi-host': 'youtube-music-api3.p.rapidapi.com',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['description'] != null &&
            data['description']['text'] != null) {
          setState(() {
            lyrics = data['description']['text'];
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching lyrics: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Music Details',
          style: TextStyle(
            fontFamily: 'Daydream',
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.purple[200],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/8bit_background2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      widget.musicItem['thumbnail'] ?? '',
                      width: 300,
                      height: 300,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.music_note, size: 300),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.musicItem['title'] ?? 'Unknown',
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Daydream',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.musicItem['subtitle'] ?? '',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontFamily: 'Daydream',
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                if (widget.musicItem['description'] != null)
                  Text(
                    widget.musicItem['description'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                const SizedBox(height: 20),
                if (widget.musicItem['browseId'] != null)
                  Text(
                    'Browse ID: ${widget.musicItem['browseId']}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Implement play functionality
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Playing feature coming soon!'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.play_arrow),
                        label: const Text(
                          'Play',
                          style: TextStyle(fontFamily: 'Daydream'),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple[200],
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (widget.musicItem['browseId'] != null) ...[
                        ElevatedButton.icon(
                          onPressed: isLoading ? null : fetchLyrics,
                          icon: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      color: Colors.white),
                                )
                              : const Icon(Icons.lyrics),
                          label: Text(
                            isLoading ? 'Loading...' : 'View Lyrics',
                            style: const TextStyle(fontFamily: 'Daydream'),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[400],
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                          ),
                        ),
                        if (lyrics != null) ...[
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              lyrics!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
