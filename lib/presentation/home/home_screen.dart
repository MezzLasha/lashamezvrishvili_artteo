import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lashamezvrishvili_artteo/presentation/home/expanded_image_screen.dart';
import 'package:lashamezvrishvili_artteo/presentation/scan/scan_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<String>> fetchImagesFromApi() async {
    final data =
        await http.get(Uri.parse('https://dog.ceo/api/breeds/image/random/10'));
    if (data.statusCode == 200) {
      final List<String> images = [];
      final json = jsonDecode(data.body);
      for (final item in json['message']) {
        images.add(item);
      }
      return images;
    }
    throw Exception('Failed to load images');
  }

  late Future<List<String>> future;

  @override
  void initState() {
    future = fetchImagesFromApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Random Dog Photos')),
        drawer: Drawer(
          child: Column(
            children: [
              Expanded(
                child: NavigationDrawer(
                  selectedIndex: 0,
                  onDestinationSelected: (value) {
                    switch (value) {
                      case 0:
                        Navigator.pop(context);
                        break;
                      case 1:
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ScanScreen()));
                        break;
                      default:
                    }
                  },
                  children: const [
                    NavigationDrawerDestination(
                        icon: Icon(Icons.home), label: Text('Home')),
                    NavigationDrawerDestination(
                        icon: Icon(Icons.qr_code), label: Text('Scan')),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              return RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    future = fetchImagesFromApi();
                  });
                },
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return DoggoImageWidget(
                      images: snapshot.data!,
                      index: index,
                    );
                  },
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ));
  }
}

class DoggoImageWidget extends StatelessWidget {
  const DoggoImageWidget({
    super.key,
    required this.index,
    required this.images,
  });

  final int index;
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'image$index',
      createRectTween: (begin, end) {
        return MaterialRectCenterArcTween(
          begin: begin,
          end: end,
        );
      },
      placeholderBuilder: (context, heroSize, child) {
        return SizedBox(
          width: heroSize.width,
          height: heroSize.height,
          child: child,
        );
      },
      child: Material(
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return ExpandedImageScreen(
                  index: index,
                  images: images,
                );
              },
            ));
          },
          child: Ink.image(
            image: NetworkImage(images[index]),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
