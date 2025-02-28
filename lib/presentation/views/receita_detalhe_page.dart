import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/receita_model.dart';

class ReceitaDetalhesPage extends StatelessWidget {
  final ReceitaModel receita;
  final String backgroundUrl =
      "https://ufbvcaxhedzauecrgiwd.supabase.co/storage/v1/object/public/background/background3.jpg";

  const ReceitaDetalhesPage({super.key, required this.receita});

  @override
  Widget build(BuildContext context) {
    // Formatação do valor em moeda brasileira
    final valorFormatado =
        NumberFormat.simpleCurrency(locale: 'pt_BR').format(receita.valor);

    // Formatação da data
    final dataFormatada = DateFormat('dd/MM/yyyy HH:mm').format(receita.data);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detalhes da Receita',
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
            children: <Widget>[
              const Text(
                'Título:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                receita.titulo,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                'Descrição:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                receita.descricao,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                'Data:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                dataFormatada,
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
