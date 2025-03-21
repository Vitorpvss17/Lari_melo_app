import 'package:estetica_app/presentation/views/cliente_perfil_page.dart';
import 'package:flutter/material.dart';

import '../../data/models/agendamento_model.dart';
import '../../data/models/cliente_model.dart';
import '../../data/repositories/agendamento_repository.dart';
import '../../data/repositories/cliente_repository.dart';
import '../viewmodels/forms/cliente_form.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ClienteRepository _clienteRepository = ClienteRepository();
  final AgendamentoRepository _agendamentoRepository = AgendamentoRepository();

  List<ClienteModel> _clientes = [];
  List<AgendamentoModel> _agendamentos = [];
  String _searchQuery = "";
  String _filtroAgendamento = "dia";

  final String backgroundUrl =
      "https://ufbvcaxhedzauecrgiwd.supabase.co/storage/v1/object/public/background/background3.jpg";
  final String logoUrl =
      "https://ufbvcaxhedzauecrgiwd.supabase.co/storage/v1/object/public/Logo/Logo.jpg";

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final clientes = await _clienteRepository.fetchClientes();
      final agendamentos = await _agendamentoRepository.fetchAllAgendamentos();
      setState(() {
        _clientes = clientes;
        _agendamentos = agendamentos;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar dados: $e')),
      );
    }
  }

  Future<void> _deleteCliente(int id) async {
    try {
      await _clienteRepository.deleteCliente(id);
      setState(() {
        _clientes.removeWhere((cliente) => cliente.id == id);
      });
      setState(() {
        _agendamentos.removeWhere((agendamento) => agendamento.clienteId == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Cliente e dados relacionados excluídos com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Erro ao excluir cliente e dados relacionados: $e')),
      );
    }
  }

  String getImageUrl(String imagePath) {
    if (imagePath.isEmpty) return "";

    final fileName = imagePath.split('/').last;
    const supabaseBucketUrl =
        "https://ufbvcaxhedzauecrgiwd.supabase.co/storage/v1/object/public/clientes_fotos/";

    final fullUrl = "$supabaseBucketUrl$fileName";
    print("URL completa: $fullUrl");

    return fullUrl;
  }

  @override
  Widget build(BuildContext context) {
    final filteredClientes = _clientes
        .where((cliente) =>
            cliente.nome.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    final filteredAgendamentos = _agendamentos.where((agendamento) {
      final now = DateTime.now();
      if (_filtroAgendamento == "dia") {
        return agendamento.data.year == now.year &&
            agendamento.data.month == now.month &&
            agendamento.data.day == now.day;
      } else if (_filtroAgendamento == "mes") {
        return agendamento.data.year == now.year &&
            agendamento.data.month == now.month;
      } else if (_filtroAgendamento == "ano") {
        return agendamento.data.year == now.year;
      }
      return false;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        leading: Image.network(
          logoUrl,
        ),
        title: const Text(
          'Bem vinda, Dra. Larissa Melo!',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              color: Colors.grey),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(backgroundUrl), fit: BoxFit.cover),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campo de busca
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Buscar Cliente',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Lista de Clientes
              Expanded(
                child: filteredClientes.isEmpty
                    ? const Center(child: Text('Nenhum cliente encontrado.'))
                    : ListView.builder(
                        itemCount: filteredClientes.length,
                        itemBuilder: (context, index) {
                          final cliente = filteredClientes[index];
                          return ListTile(
                            leading: cliente.foto.isNotEmpty
                                ? CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(getImageUrl(cliente.foto)),
                                  )
                                : const CircleAvatar(
                                    child: Icon(Icons.person),
                                  ),
                            title: Text('${cliente.nome} ${cliente.sobrenome}'),
                            subtitle: Text(cliente.email),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ClienteViewPage(cliente: cliente),
                                ),
                              ).then((_) => _loadData());
                            },
                            trailing: IconButton(
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Excluir Cliente'),
                                    content: const Text(
                                        'Tem certeza que deseja excluir este cliente?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('Cancelar'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text('Excluir'),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm ?? false) {
                                  await _deleteCliente(cliente.id);
                                }
                              },
                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 16),

              // Filtro e Lista de Agendamentos
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton<String>(
                    value: _filtroAgendamento,
                    items: const [
                      DropdownMenuItem(value: "dia", child: Text("Hoje")),
                      DropdownMenuItem(value: "mes", child: Text("Este mês")),
                      DropdownMenuItem(value: "ano", child: Text("Este ano")),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _filtroAgendamento = value!;
                      });
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CriarClientePage()),
                      ).then((_) => _loadData());
                    },
                    child:  const Column(
                      children: [
                        Icon(Icons.add_circle_outline),
                        SizedBox(width: 10),
                        Text('Adicionar Cliente'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Expanded(
                child: filteredAgendamentos.isEmpty
                    ? const Center(
                        child: Text('Nenhum agendamento encontrado.'))
                    : ListView.builder(
                        itemCount: filteredAgendamentos.length,
                        itemBuilder: (context, index) {
                          final agendamento = filteredAgendamentos[index];
                          return ListTile(
                            title: Text('Serviço: ${agendamento.servico}'),
                            subtitle: Text('Data: ${agendamento.data}'),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
