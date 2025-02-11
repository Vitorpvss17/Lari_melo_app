import 'package:flutter/material.dart';
import '../../data/models/agendamento_model.dart';
import '../../data/models/cliente_model.dart';
import '../../data/models/procedimento_model.dart';
import '../../data/models/receita_model.dart';
import '../../data/repositories/agendamento_repository.dart';
import '../../data/repositories/procedimento_repository.dart';
import '../../data/repositories/receita_repository.dart';
import '../viewmodels/forms/procedimento_form.dart';
import '../viewmodels/forms/receita_form.dart';
import '../widgets/agendamento_widget.dart';
import '../widgets/cliente_info_widget.dart';
import '../widgets/procedimento_list_widget.dart';
import '../widgets/receita_list_widget.dart';

class ClienteViewPage extends StatefulWidget {
  final ClienteModel cliente;

  const ClienteViewPage({super.key, required this.cliente});

  @override
  _ClienteViewPageState createState() => _ClienteViewPageState();
}

class _ClienteViewPageState extends State<ClienteViewPage> {
  late Future<List<AgendamentoModel>> _agendamentos;
  late Future<List<ReceitaModel>> _receitas;
  late Future<List<ProcedimentoModel>> _procedimentos;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final TextEditingController _servicoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  void _carregarDados() {
    setState(() {
      _agendamentos = AgendamentoRepository().fetchAgendamentos(clienteId: widget.cliente.id);
      _receitas = ReceitaRepository().fetchReceitas(clienteId: widget.cliente.id);
      _procedimentos = ProcedimentoRepository().fetchProcedimentos(clienteId: widget.cliente.id);
    });
  }

  Future<void> _excluirReceita(int receitaId) async {
    await ReceitaRepository().deleteReceita(receitaId);
    _carregarDados(); // Recarrega os dados após excluir
  }

  Future<void> _excluirProcedimento(int procedimentoId) async {
    await ProcedimentoRepository().deleteProcedimento(procedimentoId);
    _carregarDados(); // Recarrega os dados após excluir
  }

  Future<void> _excluirAgendamento(int agendamentoId) async {
    await AgendamentoRepository().deleteAgendamento(agendamentoId);
    _carregarDados(); // Recarrega os dados após excluir
  }

  Future<void> _selecionarData(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selecionarHora(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _confirmarAgendamento() async {
    if (_selectedDate != null && _selectedTime != null && _servicoController.text.isNotEmpty) {
      // Combina a data e a hora selecionadas
      final DateTime fullDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      // Cria um novo objeto AgendamentoModel
      AgendamentoModel novoAgendamento = AgendamentoModel(
        clienteId: widget.cliente.id,
        data: fullDateTime,
        servico: _servicoController.text, // Captura o serviço inserido
      );

      try {
        // Salva o agendamento no banco de dados
        await AgendamentoRepository().addAgendamento(novoAgendamento);

        // Atualiza a lista de agendamentos
        setState(() {
          _agendamentos = AgendamentoRepository().fetchAgendamentos(clienteId: widget.cliente.id);
        });

        // Exibe uma mensagem de sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Agendamento criado com sucesso!')),
        );

        // Limpa o campo de serviço após o agendamento
        _servicoController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao criar agendamento: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos.')),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil do Cliente'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClienteInfoWidget(cliente: widget.cliente),
            const SizedBox(height: 20),
            FutureBuilder<List<AgendamentoModel>>(
              future: _agendamentos,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Erro ao carregar agendamentos.'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Nenhum agendamento encontrado.'));
                } else {
                  final agendamentos = snapshot.data!;
                  return AgendamentosWidget(
                    agendamentos: agendamentos,
                    excluirAgendamento: _excluirAgendamento,
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            FutureBuilder<List<ReceitaModel>>(
              future: _receitas,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Erro ao carregar receitas.'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Nenhuma receita encontrada.'));
                } else {
                  final receitas = snapshot.data!;
                  return ReceitasWidget(
                    receitas: receitas,
                    excluirReceita: _excluirReceita,
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            FutureBuilder<List<ProcedimentoModel>>(
              future: _procedimentos,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Erro ao carregar procedimentos.'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Nenhum procedimento encontrado.'));
                } else {
                  final procedimentos = snapshot.data!;
                  return ProcedimentosWidget(
                    procedimentos: procedimentos,
                    excluirProcedimento: _excluirProcedimento,
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Criar Agendamento'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Campo de texto para inserir o serviço
                              TextFormField(
                                controller: _servicoController,
                                decoration: const InputDecoration(
                                  labelText: 'Serviço',
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Botão para selecionar a data
                              ElevatedButton(
                                onPressed: () async {
                                  await _selecionarData(context);
                                },
                                child: Text(_selectedDate == null
                                    ? 'Selecionar Data'
                                    : 'Data: ${_selectedDate!.toLocal().toString().split(' ')[0]}'),
                              ),
                              const SizedBox(height: 8),
                              // Botão para selecionar a hora
                              ElevatedButton(
                                onPressed: () async {
                                  await _selecionarHora(context);
                                },
                                child: Text(_selectedTime == null
                                    ? 'Selecionar Hora'
                                    : 'Hora: ${_selectedTime!.format(context)}'),
                              ),
                            ],
                          ),
                          actions: [
                            // Botão de cancelar
                            TextButton(
                              child: const Text('Cancelar'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            // Botão de confirmar o agendamento
                            TextButton(
                              child: const Text('Confirmar'),
                              onPressed: () async {
                                await _confirmarAgendamento();
                                Navigator.of(context).pop(); // Fechar o pop-up
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('Agendar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CriarReceitaPage(clienteId: widget.cliente.id),
                      ),
                    ).then((_) => _carregarDados()); // Recarrega os dados após retornar
                  },
                  child: const Text('Nova Receita'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CriarProcedimentoPage(clienteId: widget.cliente.id),
                      ),
                    ).then((_) => _carregarDados()); // Recarrega os dados após retornar
                  },
                  child: const Text('Novo Procedimento'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}