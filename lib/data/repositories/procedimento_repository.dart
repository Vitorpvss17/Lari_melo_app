import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/procedimento_model.dart';

class ProcedimentoRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  // Busca a lista de procedimentos
  Future<List<ProcedimentoModel>> fetchProcedimentos({required int clienteId}) async {
    try {
      final response = await supabase
          .from('procedimento')
          .select()
          .eq('clienteId', clienteId);  // Filtra por clienteID
      return response.map((e) => ProcedimentoModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception("Erro ao carregar Procedimento: $e");
    }
  }

  // Adiciona um novo procedimento
  Future<void> addProcedimento(ProcedimentoModel procedimento) async {
    try {
      await supabase
          .from('procedimento')
          .insert(procedimento.toJson());
    } catch (e) {
      throw Exception("Erro ao adicionar procedimento: $e");
    }
  }

  // Atualiza um procedimento existente
  Future<void> updateProcedimento(ProcedimentoModel procedimento) async {
    try {
      await supabase
          .from('procedimento')
          .update(procedimento.toJson())
          .eq('id', procedimento.id);
    } catch (e) {
      throw Exception("Erro ao atualizar procedimento: $e");
    }
  }

  // Deleta um procedimento
  Future<void> deleteProcedimento(int id) async {
    try {
      await supabase
          .from('procedimento')
          .delete()
          .eq('id', id);
    } catch (e) {
      throw Exception("Erro ao deletar procedimento: $e");
    }
  }
}