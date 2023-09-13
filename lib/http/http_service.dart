import 'dart:convert';

import 'package:http/http.dart';
import 'package:wordie_1/models/model_word.dart';

class HttpService {
  final String wordsUrl =
      "https://api.dictionaryapi.dev/api/v2/entries/en/scout";

  Future<List<WordModel>> getWords() async {
    Response res = await get(Uri.parse(wordsUrl));

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);

      List<WordModel> words =
          body.map((dynamic item) => WordModel.fromJson(item)).toList();

      return words;
    } else {
      throw "cant get words";
    }
  }
}
