import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/models/procedimento_model.dart';
import '../../../data/repositories/procedimento_repository.dart';


class CriarProcedimentoPage extends StatefulWidget {
  final int clienteId;

  const CriarProcedimentoPage({super.key, required this.clienteId});

  @override
  _CriarProcedimentoPageState createState() => _CriarProcedimentoPageState();
}

class _CriarProcedimentoPageState extends State<CriarProcedimentoPage> {
  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();
  final _tituloController = TextEditingController();
  final _valorController = TextEditingController();
  DateTime _dataSelecionada = DateTime.now();

  bool _isSaving = false;

  final _procedimentoRepository = ProcedimentoRepository();

  @override
  void dispose() {
    _descricaoController.dispose();
    _tituloController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  Future<void> _salvarProcedimento() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaving = true;
      });

      final novoProcedimento = ProcedimentoModel(
        clienteId: widget.clienteId,
        titulo: _tituloController.text,
        descricao: _descricaoController.text,
        valor: double.parse(_valorController.text),
        data: _dataSelecionada,
      );

      try {
        await _procedimentoRepository.addProcedimento(novoProcedimento);
        setState(() {
          _isSaving = false;
        });
        Navigator.pop(context, true);
      } catch (e) {
        setState(() {
          _isSaving = false;
        });
        _mostrarErro('Não foi possível salvar o procedimento. Erro: $e');
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
    if (dataSelecionada != null && dataSelecionada != _dataSelecionada) {
      setState(() {
        _dataSelecionada = dataSelecionada;
      });
    }
  }

  void _mostrarErro(String mensagem) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erro'),
        content: Text(mensagem),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd/MM/yyyy').format(_dataSelecionada);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Procedimento'),
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
                validator: (value) => value?.isEmpty ?? true ? 'Por favor, insira o título' : null,
              ),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                validator: (value) => value?.isEmpty ?? true ? 'Por favor, insira a descrição' : null,
              ),
              TextFormField(
                controller: _valorController,
                decoration: const InputDecoration(labelText: 'Valor'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Por favor, insira o valor';
                  try {
                    double parsedValue = double.parse(value!);
                    if (parsedValue <= 0) return 'O valor deve ser maior que zero';
                  } catch (e) {
                    return 'Por favor, insira um valor válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Text(
                    'Data: $formattedDate',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _selecionarData(context),
                    child: const Text('Selecionar Data'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isSaving ? null : _salvarProcedimento,
                child: _isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}