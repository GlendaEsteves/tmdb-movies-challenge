import 'package:flutter/material.dart';
import 'package:tmdb_movies/model/movie_details.dart';
import 'details_builder.dart';

class OfflineDetailsBuilder extends StatefulWidget {
  const OfflineDetailsBuilder({required this.offlineDetails, Key? key})
      : super(key: key);

  final Future<MovieDetailsModel> offlineDetails;

  @override
  State<OfflineDetailsBuilder> createState() => _MovieDetailsBuilderState();
}

class _MovieDetailsBuilderState extends State<OfflineDetailsBuilder> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<MovieDetailsModel>(
        future: widget.offlineDetails,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return DetailsBuilder(details: snapshot.data!);
          } else if (snapshot.hasError) {
            return Text('Ocorreu o seguinte erro: ${snapshot.error}');
          }
          const Text('Carregando dados');
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
