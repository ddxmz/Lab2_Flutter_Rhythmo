import 'package:flutter/material.dart';
import 'song_data.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _bio = "No bio yet. Tap the edit button to add one.";

  void _editBio() {
    final TextEditingController bioController =
        TextEditingController(text: _bio);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Bio'),
          content: TextField(
            controller: bioController,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Enter your bio'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _bio = "No bio yet. Tap the edit button to add one.";
                });
                Navigator.pop(context);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _bio = bioController.text;
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final favoriteSongs = songsList.where((song) => song.isFavorite).toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/sun.png', width: 24, height: 24),
            const SizedBox(width: 8),
            const Text(
              'Profile',
              style: TextStyle(
                fontFamily: 'Daydream',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/images/image.png'),
                ),
                SizedBox(width: 16),
                Text(
                  'Username',
                  style: TextStyle(
                    fontFamily: 'Daydream',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset('assets/images/comm.png', width: 24, height: 24),
                    const SizedBox(width: 8),
                    const Text(
                      'Bio',
                      style: TextStyle(
                        fontFamily: 'Daydream',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: _editBio,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _bio,
              style: const TextStyle(fontFamily: 'Daydream', fontSize: 16),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Image.asset('assets/images/pixel_heart.png', width: 24, height: 24),
                const SizedBox(width: 8),
                const Text(
                  'Favorite Songs',
                  style: TextStyle(
                    fontFamily: 'Daydream',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: favoriteSongs.isEmpty
                  ? const Center(
                      child: Text(
                        'No favorite songs yet.',
                        style: TextStyle(fontFamily: 'Daydream', fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: favoriteSongs.length,
                      itemBuilder: (context, index) {
                        final song = favoriteSongs[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.network(
                                song.coverUrl,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              song.title,
                              style: const TextStyle(
                                fontFamily: 'Daydream',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              song.artist,
                              style: const TextStyle(fontFamily: 'Daydream'),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 18, fontFamily: 'Daydream'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
