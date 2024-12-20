import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'joke.dart';

class JokeService {
  static const String _jokesCacheKey = 'cached_jokes';

  // Fetch jokes from the API
  Future<List<Joke>> fetchJokes() async {
    try {
      final response = await http.get(Uri.parse('https://official-joke-api.appspot.com/jokes/ten'));

      if (response.statusCode == 200) {
        List<dynamic> jokesJson = json.decode(response.body);
        List<Joke> jokes = jokesJson.map((jokeJson) => Joke.fromJson(jokeJson)).toList();

        // Cache the jokes
        await _cacheJokes(jokes);

        // Return only the first 5 jokes
        return jokes.take(5).toList();
      } else {
        throw Exception('Failed to load jokes');
      }
    } catch (e) {
      throw Exception('Failed to load jokes');
    }
  }

  // Get jokes from cache (Shared Preferences)
  Future<List<Joke>> getCachedJokes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jokesJson = prefs.getString(_jokesCacheKey);

    if (jokesJson != null) {
      List<dynamic> jokesList = json.decode(jokesJson);
      return jokesList.map((jokeJson) => Joke.fromJson(jokeJson)).toList();
    } else {
      return [];
    }
  }

  // Cache jokes in SharedPreferences
  Future<void> _cacheJokes(List<Joke> jokes) async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> jokesJson = jokes.map((joke) => joke.toJson()).toList();
    prefs.setString(_jokesCacheKey, json.encode(jokesJson));
  }
}