import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
    return Center(
      child: FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Image.network(
                  snapshot.data![index],
                  fit: BoxFit.cover,
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
