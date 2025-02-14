import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/agendamento_model.dart';

class AgendamentoRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  // Busca a lista de agendamentos
  Future<List<AgendamentoModel>> fetchAgendamentos({required int clienteId}) async {
    try {
      final List<dynamic> response = await supabase
          .from('agendamento')
          .select()
          .eq('clienteId', clienteId);
      return response.map((e) => AgendamentoModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception("Erro ao carregar agendamentos: $e");
    }
  }

  Future<List<AgendamentoModel>> fetchAllAgendamentos() async {
    try {
      final response = await supabase
          .from('agendamento')
          .select();

      return response.map((e) => AgendamentoModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception("Erro ao carregar agendamentos: $e");
    }
  }


  // Adiciona um novo agendamento
  Future<void> addAgendamento(AgendamentoModel agendamento) async {
    try {
       await supabase
          .from('agendamento')
          .insert(agendamento.toJson());
    } catch (e) {
      throw Exception("Erro ao adicionar agendamento: $e");
    }
  }

  // Atualiza um agendamento existente
  Future<void> updateAgendamento(AgendamentoModel agendamento) async {
    try {
       await supabase
          .from('agendamento')
          .update(agendamento.toJson())
          .eq('id', agendamento.id);

    } catch (e) {
      throw Exception("Erro ao atualizar agendamento: $e");
    }
  }

  // Deleta um agendamento
  Future<void> deleteAgendamento(int id) async {
    try {
      await supabase
          .from('agendamento')
          .delete()
          .eq('id', id);

    } catch (e) {
      throw Exception("Erro ao deletar agendamento: $e");
    }
  }
}