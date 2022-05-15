import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tmdb_movies/view/movie_details_screen.dart';
import 'movies.dart';

class MovieCards extends StatelessWidget {
  const MovieCards({required this.list, Key? key}) : super(key: key);

  final List<Movies> list;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Card(
            child: Column(children: [
              ListTile(
                leading: SizedBox(
                  height: 40,
                  width: 40,
                  child: CachedNetworkImage(
                    imageUrl: list[index].poster,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                title: Text(list[index].title),
                trailing: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MovieDetails(id: list[index].id)));
                    }),
              ),
            ]),
          );
        },
      ),
    );
  }
}
