// To parse this JSON data, do
//
//     final upComingResponse = upComingResponseFromMap(jsonString);

import 'dart:convert';

import 'models.dart';

class UpComingResponse {
    UpComingResponse({
        required this.dates,
        required this.page,
        required this.results,
        required this.totalPages,
        required this.totalResults,
    });

    Dates dates;
    int page;
    List<Movie> results;
    int totalPages;
    int totalResults;

    factory UpComingResponse.fromJson(String str) => UpComingResponse.fromMap(json.decode(str));

    factory UpComingResponse.fromMap(Map<String, dynamic> json) => UpComingResponse(
        dates: Dates.fromMap(json["dates"]),
        page: json["page"],
        results: List<Movie>.from(json["results"].map((x) => Movie.fromMap(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
    );

}
