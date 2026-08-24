import 'package:flutter/material.dart';

class MediaLibraryScreen extends StatefulWidget {
  const MediaLibraryScreen({super.key});

  @override
  State<MediaLibraryScreen> createState() => _MediaLibraryScreenState();
}

class _MediaLibraryScreenState extends State<MediaLibraryScreen> {
  List<String> folders = ['Clouds', 'Cars', 'Urban', 'Mountains', 'Ocean'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text(''), backgroundColor: Colors.white),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
                child: 
                  Column(
                    children: [
                      const SizedBox(height: 12),
                      const Text(
                        'Media Library',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1,
                        ),
                      ),
                    ],
                  ),
              ),

              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  itemCount: folders.length,
                  itemBuilder: (context, index) {
                    final folder = folders[index];

                    return Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.folder, color: Colors.blue),
                          title: Text(folder),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            print('Tapped $folder');
                          },
                        ),
                        const Divider(height: 1),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
