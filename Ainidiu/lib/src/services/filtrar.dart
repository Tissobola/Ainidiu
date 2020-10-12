import 'package:ainidiu/src/services/firebase_repository.dart';

class Filtrar {
  FbRepository repository = FbRepository();

  Future<List> lerBlacklist() async {
    List<String> palavras = await repository.filtro();
    return palavras;
  }

  Future<bool> filtrarTexto(String msg) async {
    List<String> listaDePalavras = await lerBlacklist();
    msg = msg.toLowerCase();
    bool ehOfensivo = false;
    for (int i = 0; i < listaDePalavras.length; i++) {
      bool aux = msg.contains(listaDePalavras[i]);
    
      if (aux == true) {
        ehOfensivo = true;
      }
    }
    return ehOfensivo;
  }
}
