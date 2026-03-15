import 'package:http/http.dart';

class MockCase {
  late String name;
  late String description;
  late Future<Response?> response;
  MockCase({
    required this.name,
    required this.description,
    required this.response
  }); 
}