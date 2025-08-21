class Song {
  final String id;
  final String title;
  final String artist;
  final String category;
  final String url;
  final String coverUrl;
  bool isFavorite;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.category,
    required this.url,
    required this.coverUrl,
    this.isFavorite = false,
  });
}

final List<Song> songsList = [
  Song(
    id: '1',
    title: 'You Belong With Me',
    artist: 'Taylor Swift',
    category: 'Pops',
    url: 'assets/mp3/taylor_swift_you_belong_with_me.mp3',
    coverUrl: 'https://upload.wikimedia.org/wikipedia/en/b/b9/Taylor_Swift_-_You_Belong_with_Me.png', // Using a placeholder image service
  ),
  Song(
    id: '2',
    title: 'OMG',
    artist: 'NewJeans',
    category: 'K-Pops',
    url: 'assets/mp3/newjeans_omg.mp3',
    coverUrl: 'https://images.genius.com/6f55bcba06040bb3d5d7b28495c61ed8.1000x1000x1.png', // Using a placeholder image service
  ),
  Song(
    id: '3',
    title: 'Psycho',
    artist: 'Red Velvet',
    category: 'K-Pops',
    url: 'assets/mp3/red_velvet_psycho.mp3',
    coverUrl: 'https://i1.sndcdn.com/artworks-W3nzbCrTukRwxQqO-7lOkfA-t500x500.jpg', // Using a placeholder image service
  ),

    Song(
    id: '4',
    title: 'Manchild',
    artist: 'Sabrina Carpenter',
    category: 'Pops',
    url: 'assets/mp3/sabrina_carpenter_manchild.mp3',
    coverUrl: 'https://upload.wikimedia.org/wikipedia/en/2/2c/Sabrina_Carpenter_-_Manchild.png', // Using a placeholder image service
  ),
];
