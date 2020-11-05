import 'dart:convert';

import 'package:http/http.dart' as http;

class CityServer {
  Future<List> findAll(String uf) async {
    String url = 'https://servicodados.ibge.gov.br/api/v1/localidades/estados/$uf/municipios';

    var response = await http.get(url);

    int statusCode = response.statusCode;
    var body = jsonDecode(response.body);

    if (statusCode == 200) {
      return body;
    }

    return null;
  }
}