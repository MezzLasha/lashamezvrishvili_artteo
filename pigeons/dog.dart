import 'package:pigeon/pigeon.dart';

class Dog {
  String? imageBase64;
}

@HostApi()
abstract class DogApi {
  String addWatermark(String imageBase64);
}
