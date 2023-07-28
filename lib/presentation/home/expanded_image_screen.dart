import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:lashamezvrishvili_artteo/custom/image_utils.dart';
import 'package:share_plus/share_plus.dart';

class ExpandedImageScreen extends StatefulWidget {
  const ExpandedImageScreen(
      {super.key, required this.index, required this.images});

  final int index;
  final List<String> images;

  @override
  State<ExpandedImageScreen> createState() => _ExpandedImageScreenState();
}

class _ExpandedImageScreenState extends State<ExpandedImageScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: widget.index);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Image ${widget.index + 1}'),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 50,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: () async {
                    final bytes = await addWatermarkToImageUrl(
                        widget.images[_pageController.page!.toInt()]);

                    Share.shareXFiles([
                      XFile.fromData(bytes,
                          name: 'image', mimeType: 'image/png')
                    ]);
                  },
                  icon: const Icon(Icons.share),
                  label: const Text('Share'),
                ),
                const SizedBox(width: 8.0),
                FilledButton.icon(
                    onPressed: () async {
                      final bytes = await addWatermarkToImageUrl(
                          widget.images[_pageController.page!.toInt()]);

                      await ImageGallerySaver.saveImage(bytes, quality: 100);
                    },
                    label: const Text('Save'),
                    icon: const Icon(Icons.download))
              ],
            ),
          ),
        ),
        body: PageView(
          controller: _pageController,
          children: widget.images.map(
            (e) {
              return InteractiveViewer(
                child: Center(
                  child: Hero(
                    tag: 'image${widget.images.indexOf(e)}',
                    createRectTween: (begin, end) {
                      return MaterialRectCenterArcTween(
                        begin: begin,
                        end: end,
                      );
                    },
                    child: Image.network(
                      widget.images[widget.images.indexOf(e)],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ).toList(),
        ));
  }
}
