/*
  Classe Modelo dos detalhes dos filmes
*/

class MovieDetailsModel {
  final int id;
  final String title;
  final double rating;
  final String poster;
  final List genres;
  final String releaseDate;
  final String overview;

  MovieDetailsModel(
      {required this.id,
      required this.title,
      required this.rating,
      required this.poster,
      required this.genres,
      required this.releaseDate,
      required this.overview});

  factory MovieDetailsModel.fromJson(Map<String, dynamic> json) {
    return MovieDetailsModel(
      id: json['id'],
      title: json['title'],
      rating: json['vote_average'],
      poster: json['poster_url'],
      genres: json['genres'],
      releaseDate: json['release_date'],
      overview: json['overview'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'vote_average': rating,
        'poster_url': poster,
        'genres': genres,
        'release_date': releaseDate,
        'overview': overview
      };
}
