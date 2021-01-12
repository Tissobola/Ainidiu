import 'dart:convert';
import 'package:http/http.dart' as http;

class Localidades {

  Future<List<String>> getEstado() async {
    List<UF> estados = new List<UF>();
    List<String> estadosString = new List<String>();

    final response = await http
        .get('https://servicodados.ibge.gov.br/api/v1/localidades/estados');

    if (response.statusCode == 200) {
      List jsons = json.decode(response.body);

      jsons.forEach((element) {
        estados.add(UF.fromJson(element));
      });

      estados.forEach((element) {
        estadosString.add(element.sigla);
      });

      return estadosString;
    } else {
      throw Exception('Erro ao carregar os estados');
    }
  }

  Future<List<String>> getCidades(String _currEstado) async {
    List<Cidade> cidades = new List<Cidade>();
    List<String> cidadesString = new List<String>();

    var response = await http.get(
        'https://servicodados.ibge.gov.br/api/v1/localidades/estados/$_currEstado/municipios');

    if (response.statusCode == 200) {
      List jsons = json.decode(response.body);

      jsons.forEach((element) {
        cidades.add(Cidade.fromJson(element));
      });

      cidades.forEach((element) {
        cidadesString.add(element.nome);
      });

      return cidadesString;
    } else {
      throw Exception('Erro ao carregar as cidades');
    }
  }

}

class Cidade {
  final int id;
  final String nome;

  Cidade(this.id, this.nome);

  factory Cidade.fromJson(Map<String, dynamic> json) {
    return Cidade(json['id'], json['nome']);
  }
}

class UF {
  final int id;
  final String sigla;
  final String nome;
  final Regiao regiao;

  UF(this.id, this.sigla, this.nome, this.regiao);

  factory UF.fromJson(Map<String, dynamic> json) {
    Regiao reg = Regiao.fromJson(json);

    return UF(json['id'], json['sigla'], json['nome'], reg);
  }
}

class Regiao {
  final int id;
  final String sigla;
  final String nome;

  Regiao(this.id, this.sigla, this.nome);

  factory Regiao.fromJson(Map<String, dynamic> json) {
    return Regiao(
        json['regiao']['id'], json['regiao']['sigla'], json['regiao']['nome']);
  }
}
