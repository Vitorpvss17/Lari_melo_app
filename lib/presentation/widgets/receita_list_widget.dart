import 'package:flutter/material.dart';
import '../../data/models/receita_model.dart';
import '../views/receita_detalhe_page.dart';


class ReceitasWidget extends StatelessWidget {
  final List<ReceitaModel> receitas;
  final Function(int) excluirReceita;

  const ReceitasWidget({
    super.key,
    required this.receitas,
    required this.excluirReceita,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Receitas',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: receitas.length,
          itemBuilder: (context, index) {
            final receita = receitas[index];
            return ListTile(
              title: Text(receita.titulo),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReceitaDetalhesPage(
                      receita: receita,
                    ),
                  ),
                );
              },
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  excluirReceita(receita.id);
                },
              ),
            );
          },
        ),
      ],
    );
  }
}