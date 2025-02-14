import 'package:flutter/material.dart';
import '../../data/models/agendamento_model.dart';


class AgendamentosWidget extends StatelessWidget {
  final List<AgendamentoModel> agendamentos;
  final Function(int) excluirAgendamento;

  const AgendamentosWidget({
    super.key,
    required this.agendamentos,
    required this.excluirAgendamento,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Agendamentos',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: agendamentos.length,
          itemBuilder: (context, index) {
            final agendamento = agendamentos[index];
            return ListTile(
              title: Text(agendamento.servico),
              subtitle: Text(agendamento.data.toString()),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  excluirAgendamento(agendamento.id as int);
                },
              ),
            );
          },
        ),
      ],
    );
  }
}