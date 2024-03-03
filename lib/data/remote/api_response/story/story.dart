import 'dart:ffi';

class Story {
  String? id;
  String? name;
  String? description;
  String? photoUrl;
  String? createdAt;
  double? lat ;
  double? lon ;

  Story(
      {this.id,
      this.name,
      this.description,
      this.photoUrl,
      this.createdAt,
      this.lat,
      this.lon});


  factory Story.fromMap(Map<String, dynamic> map) {
    return Story(
      id: map["id"],
      name: map["name"],
      description: map["description"],
      photoUrl: map["photoUrl"],
      createdAt: map["date"],
      lat: map["lat"],
      lon: map["lon"],
    );
  }
}
