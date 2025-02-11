import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/procedimento_model.dart';

class ProcedimentoRepository {
  final String apiUrl = "http://127.0.0.1:5000/procedimento/"; // URL da sua API
  final String apiUrl1 = "http://127.0.0.1:5000/procedimento";

  // Busca a lista de procedimentos
  Future<List<ProcedimentoModel>> fetchProcedimentos({required int clienteId}) async {
    final response = await http.get(Uri.parse('$apiUrl?clienteId=$clienteId'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((e) => ProcedimentoModel.fromJson(e)).toList();
    } else {
      throw Exception("Erro ao carregar procedimentos");
    }
  }

  // Adiciona um novo procedimento
  Future<void> addProcedimento(ProcedimentoModel procedimento) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(procedimento.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception("Erro ao adicionar procedimento");
    }
  }

  // Atualiza um procedimento existente
  Future<void> updateProcedimento(ProcedimentoModel procedimento) async {
    final response = await http.put(
      Uri.parse('$apiUrl/${procedimento.id}'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(procedimento.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Erro ao atualizar procedimento");
    }
  }

  // Deleta um procedimento
  Future<void> deleteProcedimento(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl1/$id'));

    if (response.statusCode != 200) {
      throw Exception("Erro ao deletar procedimento");
    }
  }
}
