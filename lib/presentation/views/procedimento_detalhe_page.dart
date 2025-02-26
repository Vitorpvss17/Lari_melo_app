import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/procedimento_model.dart';


class ProcedimentoDetalhesPage extends StatelessWidget {
  final ProcedimentoModel procedimento;

  const ProcedimentoDetalhesPage({
    super.key,
    required this.procedimento,
  });
  final String backgroundUrl = "https://ufbvcaxhedzauecrgiwd.supabase.co/storage/v1/object/public/background/background.jpeg";

  @override
  Widget build(BuildContext context) {
    final valorFormatado =
    NumberFormat.simpleCurrency(locale: 'pt_BR').format(procedimento.valor);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Procedimento'),
      ),
      body: Container(
        decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(backgroundUrl),
            fit: BoxFit.cover),),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Descrição:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                procedimento.descricao,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                'Data e Hora:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                DateFormat('dd/MM/yyyy HH:mm').format(procedimento.data),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                'Valor:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                valorFormatado,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
