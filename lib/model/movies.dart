class Movies {
  final int id;
  final double rating;
  final String title;
  final String poster;
  final List genres;
  final String releaseDate;

  Movies(
      {required this.id,
      required this.rating,
      required this.title,
      required this.poster,
      required this.genres,
      required this.releaseDate});

  factory Movies.fromJson(Map<String, dynamic> json) {
    return Movies(
      id: json['id'],
      rating: json['vote_average'],
      title: json['title'],
      poster: json['poster_url'],
      genres: json['genres'],
      releaseDate: json['release_date'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'vote_average': rating,
        'title': title,
        'poster_url': poster,
        'genres': genres,
        'release_date': releaseDate
      };
}
