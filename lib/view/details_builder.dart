import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tmdb_movies/model/movie_details.dart';

class DetailsBuilder extends StatelessWidget {
  const DetailsBuilder({required this.details, Key? key}) : super(key: key);

  final MovieDetailsModel details;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: [
        SizedBox(
          height: 100,
          width: 100,
          child: CachedNetworkImage(
            imageUrl: details.poster,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        Text(details.title),
        Text(details.overview),
      ]),
    );
  }
}
