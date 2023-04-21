class Album {
  Album({required this.albumName, required this.dayNotes});

  String albumName;
  List<String> dayNotes;

  Album.fromJson(Map<String, dynamic> json)
      : albumName = json['albumName'],
        dayNotes = List.from(json['dayNotes']);

  Map<String, dynamic> toJson() {
    return {
      "albumName": albumName,
      "dayNotes": dayNotes,
    };
  }
}
