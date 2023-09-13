// To parse this JSON data, do
//
//     final wordModel = wordModelFromJson(jsonString);

import 'dart:convert';

List<WordModel> wordModelFromJson(String str) =>
    List<WordModel>.from(json.decode(str).map((x) => WordModel.fromJson(x)));

String wordModelToJson(List<WordModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WordModel {
  WordModel({
    required this.word,
    required this.phonetics,
    required this.meanings,
    required this.license,
    required this.sourceUrls,
  });

  String word;
  List<Phonetic> phonetics;
  List<Meaning> meanings;
  License license;
  List<String> sourceUrls;

  factory WordModel.fromJson(Map<String, dynamic> json) => WordModel(
        word: json["word"],
        phonetics: List<Phonetic>.from(
            json["phonetics"].map((x) => Phonetic.fromJson(x))),
        meanings: List<Meaning>.from(
            json["meanings"].map((x) => Meaning.fromJson(x))),
        license: License.fromJson(json["license"]),
        sourceUrls: List<String>.from(json["sourceUrls"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "word": word,
        "phonetics": List<dynamic>.from(phonetics.map((x) => x.toJson())),
        "meanings": List<dynamic>.from(meanings.map((x) => x.toJson())),
        "license": license.toJson(),
        "sourceUrls": List<dynamic>.from(sourceUrls.map((x) => x)),
      };
}

class License {
  License({
    required this.name,
    required this.url,
  });

  Name name;
  String url;

  factory License.fromJson(Map<String, dynamic> json) => License(
        name: nameValues.map[json["name"]]!,
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "name": nameValues.reverse[name],
        "url": url,
      };
}

// ignore: constant_identifier_names
enum Name { CC_BY_SA_30, BY_SA_40 }

final nameValues =
    EnumValues({"BY-SA 4.0": Name.BY_SA_40, "CC BY-SA 3.0": Name.CC_BY_SA_30});

class Meaning {
  Meaning({
    required this.partOfSpeech,
    required this.definitions,
    required this.synonyms,
    required this.antonyms,
  });

  String partOfSpeech;
  List<Definition> definitions;
  List<dynamic> synonyms;
  List<dynamic> antonyms;

  factory Meaning.fromJson(Map<String, dynamic> json) => Meaning(
        partOfSpeech: json["partOfSpeech"],
        definitions: List<Definition>.from(
            json["definitions"].map((x) => Definition.fromJson(x))),
        synonyms: List<dynamic>.from(json["synonyms"].map((x) => x)),
        antonyms: List<dynamic>.from(json["antonyms"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "partOfSpeech": partOfSpeech,
        "definitions": List<dynamic>.from(definitions.map((x) => x.toJson())),
        "synonyms": List<dynamic>.from(synonyms.map((x) => x)),
        "antonyms": List<dynamic>.from(antonyms.map((x) => x)),
      };
}

class Definition {
  Definition({
    required this.definition,
    required this.synonyms,
    required this.antonyms,
    this.example,
  });

  String definition;
  List<dynamic> synonyms;
  List<dynamic> antonyms;
  String? example;

  factory Definition.fromJson(Map<String, dynamic> json) => Definition(
        definition: json["definition"],
        synonyms: List<dynamic>.from(json["synonyms"].map((x) => x)),
        antonyms: List<dynamic>.from(json["antonyms"].map((x) => x)),
        example: json["example"],
      );

  Map<String, dynamic> toJson() => {
        "definition": definition,
        "synonyms": List<dynamic>.from(synonyms.map((x) => x)),
        "antonyms": List<dynamic>.from(antonyms.map((x) => x)),
        "example": example,
      };
}

class Phonetic {
  Phonetic({
    required this.audio,
    this.sourceUrl,
    this.license,
    this.text,
  });

  String audio;
  String? sourceUrl;
  License? license;
  Text? text;

  factory Phonetic.fromJson(Map<String, dynamic> json) => Phonetic(
        audio: json["audio"],
        sourceUrl: json["sourceUrl"],
        license:
            json["license"] == null ? null : License.fromJson(json["license"]),
        text: textValues.map[json["text"]]!,
      );

  Map<String, dynamic> toJson() => {
        "audio": audio,
        "sourceUrl": sourceUrl,
        "license": license?.toJson(),
        "text": textValues.reverse[text],
      };
}

// ignore: constant_identifier_names
enum Text { SKT, SKAT }

final textValues = EnumValues({"/skaʊt/": Text.SKAT, "[skʌʊt]": Text.SKT});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
