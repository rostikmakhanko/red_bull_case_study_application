import 'package:flutter/material.dart';
import '../components/search_field.dart';

class MediaLibraryScreen extends StatefulWidget {
  const MediaLibraryScreen({super.key});

  @override
  State<MediaLibraryScreen> createState() => _MediaLibraryScreenState();
}

class _MediaLibraryScreenState extends State<MediaLibraryScreen> {
  List<String> folders = ['Clouds', 'Cars', 'Urban', 'Mountains', 'Ocean'];

  void _showFolderContentBottomSheet(
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => const FolderContentSheet(),
    );
  }

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
                    crossAxisAlignment: CrossAxisAlignment.start,
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

                      const SizedBox(height: 12),
                      SearchField(hintText: 'Seatch folders'),
                      const SizedBox(height: 12),
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
                            _showFolderContentBottomSheet(context);
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

class FolderContentSheet extends StatefulWidget {
  const FolderContentSheet({super.key});

  @override
  State<FolderContentSheet> createState() => _FolderContentSheetState();
}

class _FolderContentSheetState extends State<FolderContentSheet> {
  @override
  Widget build(BuildContext context) {
    // TODO: investigate why topBarHeight is 0
    // final topBarHeight = MediaQuery.viewInsetsOf(context).top;
    final sheetHeight = 0.8 * MediaQuery.of(context).size.height;

    return SizedBox(
      height: sheetHeight,
      child: Column(
        children: [
          SearchField(hintText: 'Search in folder'),
          const Text('alley_night.mp4'),
          const Text('alley_night_2.mp4'),
          const Text('alley_night_3.mp4'),
        ],
      ),
    );
  }
}