import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tmdb_movies/model/cards.dart';
import 'package:tmdb_movies/model/movies.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const TmdbMoviesApp());
}

class TmdbMoviesApp extends StatelessWidget {
  const TmdbMoviesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TMDB Movies',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const MyHomePage(title: 'TMDB Movies'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Movies>> futureMoviesList;

  @override
  void initState() {
    super.initState();
    futureMoviesList = fetchMoviesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<List<Movies>>(
          future: futureMoviesList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return MovieCards(list: snapshot.data!);
            } else if (snapshot.hasError) {
              return Text('Ocorreu o seguinte erro: ${snapshot.error}');
            }
            const Text('Carregando dados');
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

Future<List<Movies>> fetchMoviesList() async {
  List<Movies> moviesList = [];

  final response = await http.get(
      Uri.parse('https://desafio-mobile.nyc3.digitaloceanspaces.com/movies'));
  if (response.statusCode == 200) {
    var list = jsonDecode(response.body);
    for (var movie in list) {
      moviesList.add(Movies.fromJson(movie));
    }
    return moviesList;
  } else {
    throw Exception('Erro ao carregar filmes');
  }
}
