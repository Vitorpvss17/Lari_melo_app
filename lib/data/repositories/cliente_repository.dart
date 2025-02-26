import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/cliente_model.dart';

class ClienteRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  // Busca a lista de clientes
  Future<List<ClienteModel>> fetchClientes() async {
    try {
      final response = await supabase
          .from('clientes')
          .select();

      return response.map((e) => ClienteModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception("Erro ao carregar clientes: $e");
    }
  }

  // Adiciona um novo cliente
  Future<void> addCliente(ClienteModel cliente) async {
    try {
      await supabase
          .from('clientes')
          .insert(cliente.toJson());

    } catch (e) {
      throw Exception("Erro ao adicionar cliente: $e");
    }
  }

  // Atualiza um cliente existente
  Future<void> updateCliente(ClienteModel cliente) async {
    try {
      await supabase
          .from('clientes')
          .update(cliente.toJson())
          .eq('id', cliente.id);

    } catch (e) {
      throw Exception("Erro ao atualizar cliente: $e");
    }
  }

  Future<void> deleteCliente(int id) async {
    try {
      final cliente = await supabase
          .from('clientes')
          .select('foto')
          .eq('id', id)
          .single();

      if (cliente['foto'] != null && cliente['foto'].isNotEmpty) {
        final fileName = cliente['foto'].split('/').last;
        await supabase
            .storage
            .from('clientes_fotos')
            .remove([fileName]);
      }
      await supabase
          .from('receitas')
          .delete()
          .eq('clienteId', id);

      await supabase
          .from('procedimento')
          .delete()
          .eq('clienteId', id);

      await supabase
          .from('agendamento')
          .delete()
          .eq('clienteId', id);
      await supabase
          .from('clientes')
          .delete()
          .eq('id', id);

    } catch (e) {
      throw Exception("Erro ao deletar cliente e dados relacionados: $e");
    }
  }
}