import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lashamezvrishvili_artteo/presentation/home/expanded_image_screen.dart';

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
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
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
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
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
