import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiMovies {
  static const String url = 'https://api.themoviedb.org/3/movie/top_rated?api_key=bf091621962bdf5c30339e874a2a0c1a&language=en-US&page=1';

  Future getMovies() async {
    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200) {
      final json = jsonDecode(response.body);

      return json['results'];
    } else {
      throw Exception('Error al obtener las movies');
    }
  }
}
