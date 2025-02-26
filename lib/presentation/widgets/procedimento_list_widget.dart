import 'package:flutter/material.dart';
import '../../data/models/procedimento_model.dart';
import '../views/procedimento_detalhe_page.dart';


class ProcedimentosWidget extends StatelessWidget {
  final List<ProcedimentoModel> procedimentos;
  final Function(int) excluirProcedimento;

  const ProcedimentosWidget({
    super.key,
    required this.procedimentos,
    required this.excluirProcedimento,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Procedimentos',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: procedimentos.length,
          itemBuilder: (context, index) {
            final procedimento = procedimentos[index];
            return ListTile(
              title: Text(procedimento.titulo),
              subtitle: Text(
                'Valor: R\$${procedimento.valor.toStringAsFixed(2)}',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  excluirProcedimento(procedimento.id);
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProcedimentoDetalhesPage(
                      procedimento: procedimento,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
