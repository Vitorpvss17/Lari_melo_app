import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/agendamento_model.dart';

class AgendamentoRepository {
  final String apiUrl = "http://127.0.0.1:5000/agendamento";
  final String apiUrl1 = "http://127.0.0.1:5000/agendamento/";

  // Busca a lista de agendamentos
  Future<List<AgendamentoModel>> fetchAgendamentos({required int clienteId}) async {
    final response = await http.get(Uri.parse('$apiUrl?clienteId=$clienteId'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((e) => AgendamentoModel.fromJson(e)).toList();
    } else {
      throw Exception("Erro ao carregar agendamentos");
    }
  }

  Future<List<AgendamentoModel>> fetchAllAgendamentos() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((e) => AgendamentoModel.fromJson(e)).toList();
    } else {
      throw Exception("Erro ao carregar agendamentos");
    }
  }

  // Adiciona um novo agendamento
  Future<void> addAgendamento(AgendamentoModel agendamento) async {
    final response = await http.post(
      Uri.parse(apiUrl1),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(agendamento.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception("Erro ao adicionar agendamento");
    }
  }

  // Atualiza um agendamento existente
  Future<void> updateAgendamento(AgendamentoModel agendamento) async {
    final response = await http.put(
      Uri.parse('$apiUrl/${agendamento.id}'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(agendamento.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Erro ao atualizar agendamento");
    }
  }

  // Deleta um agendamento
  Future<void> deleteAgendamento(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception("Erro ao deletar agendamento");
    }
  }
}
