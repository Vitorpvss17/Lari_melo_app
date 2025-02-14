import 'package:flutter/material.dart';

import '../../../data/models/receita_model.dart';
import '../../../data/repositories/receita_repository.dart';

class CriarReceitaPage extends StatefulWidget {
  final int clienteId;

  const CriarReceitaPage({Key? key, required this.clienteId}) : super(key: key);

  @override
  _CriarReceitaPageState createState() => _CriarReceitaPageState();
}

class _CriarReceitaPageState extends State<CriarReceitaPage> {
  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();
  final _tituloController = TextEditingController();
  final _servicoController = TextEditingController();
  final _valorController = TextEditingController();
  DateTime _dataSelecionada = DateTime.now();

  final ReceitaRepository _receitaRepository = ReceitaRepository();

  @override
  void dispose() {
    _descricaoController.dispose();
    _tituloController.dispose();
    _valorController.dispose();
    _servicoController.dispose();
    super.dispose();
  }

  Future<void> _salvarReceita() async {
    if (_formKey.currentState!.validate()) {
      final novaReceita = ReceitaModel(
        clienteId: widget.clienteId,
        titulo: _tituloController.text,
        descricao: _descricaoController.text,
        valor: double.tryParse(_valorController.text) ?? 0.0,
        data: _dataSelecionada, servico: _servicoController.text,
        id: 0,
      );

      try {
        // Salvar receita na API
        await _receitaRepository.addReceita(novaReceita);

        // Retornar para a página anterior com sucesso
        Navigator.pop(context, true);
      } catch (e) {
        // Mostrar erro caso a operação falhe
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar receita: $e')),
        );
      }
    }
  }

  Future<void> _selecionarData(BuildContext context) async {
    final DateTime? dataSelecionada = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (dataSelecionada != null) {
      setState(() {
        _dataSelecionada = dataSelecionada;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Receita'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o título';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _servicoController,
                decoration: const InputDecoration(labelText: 'Serviço'),
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o serviço';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a descrição';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _valorController,
                decoration: const InputDecoration(labelText: 'Valor'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o valor';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Por favor, insira um valor válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Data: ${_dataSelecionada.toLocal().toString().split(' ')[0]}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  ElevatedButton(
                    onPressed: () => _selecionarData(context),
                    child: const Text('Selecionar Data'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvarReceita,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
