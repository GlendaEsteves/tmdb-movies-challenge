import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/*
  Classe que organiza as funções de salvar e ler localmente o json 
  fornecido pela API
*/
class SharedPrefs {
  read(String key) async {
    /*
    Acessa a instância do shared_preferences e, através da chave fornecida,
    decodifica os dados salvos em um objeto
    */
    final prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString(key) ?? '');
  }

  save(String key, value) async {
    /*
    Acessa a instância do shared_preferences e salva os dados do objeto em um
    json, com uma chave para identificação
    */
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  exists(String key) async {
    //Verifica se uma chave existe dentro da instância do shared_preferences
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key)) {
      return true;
    }
  }
}
