import 'package:flutter/material.dart';
import '../../data/models/cliente_model.dart';


class ClienteInfoWidget extends StatelessWidget {
  final ClienteModel cliente;

  const ClienteInfoWidget({super.key, required this.cliente});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: cliente.foto.isNotEmpty
              ? NetworkImage(cliente.foto)
              : const AssetImage('assets/default_avatar.png'),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${cliente.nome} ${cliente.sobrenome}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text('Telefone: ${cliente.telefone}'),
              const SizedBox(height: 5),
              Text('Email: ${cliente.email}'),
            ],
          ),
        ),
      ],
    );
  }
}