import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'song_data.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String _selectedCategory = 'All';
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  String? _currentlyPlayingId;
  List<Song> _filteredSongs = [];
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'All',
    'Pops',
    'K-Pops',
  ];

  @override
  void initState() {
    super.initState();
    _filteredSongs = List.from(songsList);
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildNowPlayingBar() {
    if (_currentlyPlayingId == null) return const SizedBox.shrink();

    final currentSong =
        songsList.firstWhere((song) => song.id == _currentlyPlayingId);

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                currentSong.coverUrl,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentSong.title,
                  style: const TextStyle(
                    fontFamily: 'Daydream',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  currentSong.artist,
                  style: const TextStyle(
                    fontFamily: 'Daydream',
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Image.asset(
              'assets/images/pixel_butt.png',
              width: 48,
              height: 48,
            ),
            onPressed: () {
              if (_isPlaying) {
                _audioPlayer.pause();
              } else {
                _audioPlayer.play();
              }
              setState(() {
                _isPlaying = !_isPlaying;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStarRatingBar() {
    if (_currentlyPlayingId == null) return const SizedBox.shrink();

    return Container(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/flower.png', width: 48, height: 48),
          const SizedBox(width: 8),
          Image.asset('assets/images/flower.png', width: 48, height: 48),
          const SizedBox(width: 8),
          Image.asset('assets/images/flower.png', width: 48, height: 48),
          const SizedBox(width: 8),
          Image.asset('assets/images/flower.png', width: 48, height: 48),
          const SizedBox(width: 8),
          Image.asset('assets/images/flower.png', width: 48, height: 48),
        ],
      ),
    );
  }

  Widget _buildArtistsList() {
    final query = _searchController.text.toLowerCase();
    // Get unique artists and sort them alphabetically
    final artists = songsList
        .map((song) => song.artist)
        .toSet()
        .where((artist) => artist.toLowerCase().contains(query))
        .toList()
      ..sort();

    return ListView.builder(
      itemCount: artists.length,
      itemBuilder: (context, index) {
        final artist = artists[index];
        final artistSongs =
            songsList.where((song) => song.artist == artist).toList();

        return ExpansionTile(
          leading: const Icon(Icons.person, size: 50),
          title: Text(
            artist,
            style: const TextStyle(
              fontFamily: 'Daydream',
              fontSize: 16,
            ),
          ),
          children: artistSongs
              .map((song) => ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        song.coverUrl,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      song.title,
                      style: const TextStyle(
                        fontFamily: 'Daydream',
                        fontSize: 20,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Image.asset(
                            song.isFavorite
                                ? 'assets/images/pixel_heart.png'
                                : 'assets/images/pixel_heart_open.png',
                            width: 32,
                            height: 32,
                          ),
                          onPressed: () {
                            setState(() {
                              song.isFavorite = !song.isFavorite;
                            });
                          },
                        ),
                        IconButton(
                          icon: Image.asset(
                            'assets/images/pixel_butt.png',
                            width: 32,
                            height: 32,
                          ),
                          onPressed: () async {
                            try {
                              if (_currentlyPlayingId == song.id &&
                                  _isPlaying) {
                                await _audioPlayer.pause();
                                setState(() => _isPlaying = false);
                              } else if (_currentlyPlayingId == song.id &&
                                  !_isPlaying) {
                                await _audioPlayer.play();
                                setState(() => _isPlaying = true);
                              } else {
                                await _audioPlayer.stop();
                                if (song.url.startsWith('http')) {
                                  await _audioPlayer.setUrl(song.url);
                                } else {
                                  await _audioPlayer
                                      .setAsset(song.url.replaceAll(r'\', '/'));
                                }
                                _audioPlayer.play();
                                setState(() {
                                  _currentlyPlayingId = song.id;
                                  _isPlaying = true;
                                });
                              }
                            } catch (e) {
                              print("Error playing audio: $e");
                            }
                          },
                        ),
                      ],
                    ),
                  ))
              .toList(),
        );
      },
    );
  }

  Widget _buildContent() {
    final query = _searchController.text.toLowerCase();
    switch (_selectedIndex) {
      case 1:
        // Saved/Favorites view
        final favoritesSongs = songsList
            .where((song) =>
                song.isFavorite &&
                (song.title.toLowerCase().contains(query) ||
                    song.artist.toLowerCase().contains(query)))
            .toList();
        return favoritesSongs.isEmpty
            ? const Center(
                child: Text(
                  'No favorite songs yet',
                  style: TextStyle(
                    fontFamily: 'Daydream',
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              )
            : _buildSongGrid(favoritesSongs);
      case 2:
        // Artists view
        return _buildArtistsList();
      case 3:
        // Profile view
        return const ProfilePage();
      default:
        // Home view
        final filtered = songsList.where((song) {
          final titleMatches = song.title.toLowerCase().contains(query);
          final artistMatches = song.artist.toLowerCase().contains(query);
          final categoryMatches =
              _selectedCategory == 'All' || song.category == _selectedCategory;
          return (titleMatches || artistMatches) && categoryMatches;
        }).toList();
        return _buildSongGrid(filtered);
    }
  }

  Widget _buildSongGrid(List<Song> songs) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];
        final isCurrentSong = song.id == _currentlyPlayingId;

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(20)),
                      image: DecorationImage(
                        image: NetworkImage(song.coverUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          try {
                            if (isCurrentSong && _isPlaying) {
                              await _audioPlayer.pause();
                              setState(() => _isPlaying = false);
                            } else if (isCurrentSong && !_isPlaying) {
                              await _audioPlayer.play();
                              setState(() => _isPlaying = true);
                            } else {
                              await _audioPlayer.stop();
                              if (song.url.startsWith('http')) {
                                await _audioPlayer.setUrl(song.url);
                              } else {
                                await _audioPlayer
                                    .setAsset(song.url.replaceAll(r'\', '/'));
                              }
                              _audioPlayer.play();
                              setState(() {
                                _currentlyPlayingId = song.id;
                                _isPlaying = true;
                              });
                            }
                          } catch (e) {
                            print("Error playing audio: $e");
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20)),
                            color: Colors.black26,
                          ),
                          child: Center(
                            child: isCurrentSong && _isPlaying
                                ? Image.asset(
                                    'assets/images/pixel_butt.png',
                                    width: 50,
                                    height: 50,
                                  )
                                : Image.asset(
                                    'assets/images/pixel_butt.png',
                                    width: 50,
                                    height: 50,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: IconButton(
                      icon: Image.asset(
                        song.isFavorite
                            ? 'assets/images/pixel_heart.png'
                            : 'assets/images/pixel_heart_open.png',
                        width: 24,
                        height: 24,
                      ),
                      onPressed: () {
                        setState(() {
                          song.isFavorite = !song.isFavorite;
                        });
                      },
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () async {
                  try {
                    if (isCurrentSong && _isPlaying) {
                      await _audioPlayer.pause();
                      setState(() => _isPlaying = false);
                    } else if (isCurrentSong && !_isPlaying) {
                      await _audioPlayer.play();
                      setState(() => _isPlaying = true);
                    } else {
                      await _audioPlayer.stop();
                      if (song.url.startsWith('http')) {
                        await _audioPlayer.setUrl(song.url);
                      } else {
                        await _audioPlayer
                            .setAsset(song.url.replaceAll(r'\', '/'));
                      }
                      _audioPlayer.play();
                      setState(() {
                        _currentlyPlayingId = song.id;
                        _isPlaying = true;
                      });
                    }
                  } catch (e) {
                    print("Error playing audio: $e");
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        song.title,
                        style: const TextStyle(
                          fontFamily: 'Daydream',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        song.artist,
                        style: const TextStyle(
                          fontFamily: 'Daydream',
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/pixel_mus.png',
              height: 55,
            ),
            const SizedBox(width: 12),
            const Text(
              'Rhythmo',
              style: TextStyle(
                fontFamily: 'Daydream',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by title or artist...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              if (_selectedIndex == 0) // Only show filter bar in home view
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (String category in _categories)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: FilterChip(
                              selected: _selectedCategory == category,
                              label: Text(
                                category,
                                style: TextStyle(
                                  fontFamily: 'Daydream',
                                  color: _selectedCategory == category
                                      ? Colors.black
                                      : Colors.black54,
                                ),
                              ),
                              onSelected: (bool selected) {
                                setState(() {
                                  _selectedCategory = category;
                                });
                              },
                              backgroundColor:
                                  const Color(0xFFFEFCBF), // Light yellow
                              selectedColor: const Color(
                                  0xFFEFD81D), // Darker yellow for selected state
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              labelPadding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              Expanded(
                child: _buildContent(),
              ),
              if (_currentlyPlayingId != null)
                const SizedBox(height: 80), // Space for the now playing bar
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 80,
            child: _buildStarRatingBar(),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildNowPlayingBar(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedLabelStyle: const TextStyle(fontFamily: 'Daydream'),
        unselectedLabelStyle: const TextStyle(fontFamily: 'Daydream'),
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              _selectedIndex == 0
                  ? 'assets/images/pixel_home_fill.png'
                  : 'assets/images/pixel_home.png',
              width: 24,
              height: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              _selectedIndex == 1
                  ? 'assets/images/pixel_heart.png'
                  : 'assets/images/pixel_heart_open.png',
              width: 24,
              height: 24,
            ),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              _selectedIndex == 2
                  ? 'assets/images/pixel_star.png'
                  : 'assets/images/star.png',
              width: 24,
              height: 24,
            ),
            label: 'Artists',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              _selectedIndex == 3
                  ? 'assets/images/profile_filled.png'
                  : 'assets/images/profile.png',
              width: 24,
              height: 24,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
