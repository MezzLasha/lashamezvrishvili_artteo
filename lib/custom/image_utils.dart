import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:lashamezvrishvili_artteo/pigeon.dart';

Future<String?> networkImageToBase64(String imageUrl) async {
  http.Response response = await http.get(Uri.parse(imageUrl));
  final bytes = response.bodyBytes;
  return base64Encode(bytes);
}

Future<Uint8List> addWatermarkToImageUrl(String imageUrl) async {
  String? base64 = await networkImageToBase64(imageUrl);

  DogApi api = DogApi();
  String finalPhoto = await api.addWatermark(base64!);

  final String regexedImage = finalPhoto.replaceAll(RegExp(r'\s+'), '');

  Uint8List bytes = base64Decode(regexedImage);

  return bytes;
}
