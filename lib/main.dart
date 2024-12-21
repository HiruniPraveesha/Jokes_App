import 'package:flutter/material.dart';
import 'joke_service.dart';
import 'joke.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const JokesPage(),
    );
  }
}

class JokesPage extends StatefulWidget {
  const JokesPage({super.key});

  @override
  _JokesPageState createState() => _JokesPageState();
}

class _JokesPageState extends State<JokesPage> {
  late JokeService jokeService;
  late Future<List<Joke>> jokesFuture;

  @override
  void initState() {
    super.initState();
    jokeService = JokeService();
    jokesFuture = _loadJokes();
  }

  Future<List<Joke>> _loadJokes() async {
    try {
      return await jokeService.fetchJokes();
    } catch (_) {
      List<Joke> cachedJokes = await jokeService.getCachedJokes();
      return cachedJokes.take(5).toList();
    }
  }

  void _refreshJokes() {
    setState(() {
      jokesFuture = _loadJokes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Explore latest Jokes',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<Joke>>(
        future: jokesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Failed to load jokes',
                  style: TextStyle(color: Colors.red)),
            );
          } else if (snapshot.hasData) {
            List<Joke> jokes = snapshot.data!;
            return ListView.builder(
              itemCount: jokes.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Card(
                    color: Colors.blue[100],
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            jokes[index].setup,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            jokes[index].punchline,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text('No jokes available',
                  style: TextStyle(color: Colors.blueGrey)),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshJokes,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }
}
