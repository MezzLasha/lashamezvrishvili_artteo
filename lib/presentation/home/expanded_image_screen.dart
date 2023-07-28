import 'package:flutter/material.dart';

class ExpandedImageScreen extends StatelessWidget {
  const ExpandedImageScreen(
      {super.key, required this.index, required this.images});

  final int index;
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Image ${index + 1}'),
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
                  onPressed: () {},
                  icon: const Icon(Icons.share),
                  label: const Text('Share'),
                ),
                const SizedBox(width: 8.0),
                FilledButton.icon(
                    onPressed: () {},
                    label: const Text('Save'),
                    icon: const Icon(Icons.download))
              ],
            ),
          ),
        ),
        body: PageView(
          controller: PageController(initialPage: index),
          children: images.map(
            (e) {
              return InteractiveViewer(
                child: Center(
                  child: Hero(
                    tag: 'image${images.indexOf(e)}',
                    createRectTween: (begin, end) {
                      return MaterialRectCenterArcTween(
                        begin: begin,
                        end: end,
                      );
                    },
                    child: Image.network(
                      images[images.indexOf(e)],
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
