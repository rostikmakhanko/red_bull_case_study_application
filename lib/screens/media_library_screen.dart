import 'package:flutter/material.dart';

import '../models/pixabay_media.dart';
import '../services/pixabay_service.dart';

import '../components/search_field.dart';
import '../components/media_list_tile.dart';
import '../components/media_detail_viewer.dart';
import '../components/video_detail_sheet.dart';

class MediaLibraryScreen extends StatefulWidget {
  const MediaLibraryScreen({super.key});

  @override
  State<MediaLibraryScreen> createState() => _MediaLibraryScreenState();
}

class _MediaLibraryScreenState extends State<MediaLibraryScreen> {
  List<String> folders = ['Clouds', 'Cars', 'Urban', 'Mountains', 'Ocean'];

  void _showFolderContentBottomSheet(BuildContext context, String folderName) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => FolderContentSheet(folderName: folderName),
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
                child: Column(
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
                    final folderName = folders[index];

                    return Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.folder, color: Colors.blue),
                          title: Text(folderName),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            print('Tapped $folderName');
                            _showFolderContentBottomSheet(context, folderName);
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
  final String folderName;

  const FolderContentSheet({super.key, required this.folderName});

  @override
  State<FolderContentSheet> createState() => _FolderContentSheetState();
}

class _FolderContentSheetState extends State<FolderContentSheet> {
  final _pixabayService = PixabayService();
  late Future<List<PixabayMedia>> _mediaFuture;

  @override
  void initState() {
    super.initState();
    _mediaFuture = _pixabayService.searchFolder(widget.folderName);
  }

  @override
  void dispose() {
    _pixabayService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: investigate why topBarHeight is 0
    // final topBarHeight = MediaQuery.viewInsetsOf(context).top;
    final sheetHeight = 0.8 * MediaQuery.of(context).size.height;

    return SizedBox(
      height: sheetHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 120,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.chevron_left, color: Colors.blue),
                    label: const Text(
                      'Media\nLibrary',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                        height: 1.2,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Text(
                  widget.folderName,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              SizedBox(
                width: 120,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.filter_alt, color: Colors.blue),
                    onPressed: () {
                      // TODO: implement folder content filtering
                      print('Filtering is not implemented');
                    },
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 12),
            child: SearchField(hintText: 'Search in folder'),
          ),

          Expanded(
            child: FutureBuilder<List<PixabayMedia>>(
              future: _mediaFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  print('Waiting for response');
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  print('Error ${snapshot.error}');
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}\nPlease contact rostik270900@gmail.com',
                    ),
                  );
                }

                final items = snapshot.data ?? [];
                print('Response $items');
                if (items.isEmpty) {
                  return const Center(child: Text('No results found'));
                }

                return ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) =>
                      Divider(height: 1, color: Colors.grey.shade200),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return MediaListTile(
                      item: item,
                      onTap: () {
                        if (item.kind == MediaKind.image) {
                          MediaDetailViewer.show(context, item);
                        } else {
                          VideoDetailSheet.show(context, item);
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
