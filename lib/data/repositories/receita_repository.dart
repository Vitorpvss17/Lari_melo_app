import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/receita_model.dart';

class ReceitaRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  // Busca a lista de receitas
  Future<List<ReceitaModel>> fetchReceitas({required int clienteId}) async {
    try {
      final List<dynamic> response = await supabase
          .from('receitas')
          .select()
          .eq('clienteId', clienteId);  // Filtra por clienteId

      return response.map((e) => ReceitaModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception("Erro ao carregar receitas: $e");
    }
  }

  // Adiciona uma nova receita
  Future<void> addReceita(ReceitaModel receita) async {
    try {
      await supabase
          .from('receitas')
          .insert(receita.toJson());
    } catch (e) {
      throw Exception("Erro ao adicionar receita: $e");
    }
  }

  // Atualiza uma receita existente
  Future<void> updateReceita(ReceitaModel receita) async {
    try {
      await supabase
          .from('receitas')
          .update(receita.toJson())
          .eq('id', receita.id);
    } catch (e) {
      throw Exception("Erro ao atualizar receita: $e");
    }
  }

  // Deleta uma receita
  Future<void> deleteReceita(int id) async {
    try {
      await supabase
          .from('receitas')
          .delete()
          .eq('id', id);
    } catch (e) {
      throw Exception("Erro ao deletar receita: $e");
    }
  }
}