class City {
  final String cityName;
  final String countryName;

  City ({required this.cityName, required this.countryName});

  factory City .fromJson(Map<String, dynamic> json) => City (
    cityName: json['cityName'],
    countryName: json['countryName'],
  ); 

}

class Degree {
  final String degreeMajorCategory;
  final String degreeMajor;

  Degree ({required this.degreeMajorCategory, required this.degreeMajor});

  factory Degree .fromJson(Map<String, dynamic> json) => Degree (
    degreeMajorCategory: json['degreeMajorCategory'],
    degreeMajor: json['degreeMajor'],
  );
}