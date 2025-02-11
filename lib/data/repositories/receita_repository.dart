import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/receita_model.dart';

class ReceitaRepository {
  final String apiUrl = "http://127.0.0.1:5000/receitas/"; // URL da sua API
  final String apiUrl1 = "http://127.0.0.1:5000/receitas";

  // Busca a lista de receitas
  Future<List<ReceitaModel>> fetchReceitas({required int clienteId}) async {
    final response = await http.get(Uri.parse('$apiUrl?clienteId=$clienteId'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((e) => ReceitaModel.fromJson(e)).toList();
    } else {
      throw Exception("Erro ao carregar receitas");
    }
  }

  // Adiciona uma nova receita
  Future<void> addReceita(ReceitaModel receita) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(receita.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception("Erro ao adicionar receita");
    }
  }

  // Atualiza uma receita existente
  Future<void> updateReceita(ReceitaModel receita) async {
    final response = await http.put(
      Uri.parse('$apiUrl/${receita.id}'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(receita.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Erro ao atualizar receita");
    }
  }

  // Deleta uma receita
  Future<void> deleteReceita(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl1/$id'));

    if (response.statusCode != 200) {
      throw Exception("Erro ao deletar receita");
    }
  }
}
