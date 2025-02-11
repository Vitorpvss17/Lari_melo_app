import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../data/models/cliente_model.dart';
import '../../../data/repositories/cliente_repository.dart';
import 'package:image_picker/image_picker.dart';


class CriarClientePage extends StatefulWidget {
  const CriarClientePage({super.key});

  @override
  _CriarClientePageState createState() => _CriarClientePageState();
}

class _CriarClientePageState extends State<CriarClientePage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _sobrenomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();
  String? _fotoBase64;

  final ClienteRepository _clienteRepository = ClienteRepository(); // Usando o repositório

  @override
  void dispose() {
    _nomeController.dispose();
    _sobrenomeController.dispose();
    _telefoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _salvarCliente() async {
    if (_formKey.currentState!.validate()) {
      if (_fotoBase64 == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, selecione uma foto.')),
        );
        return;
      }

      ClienteModel novoCliente = ClienteModel(
        id: DateTime.now().millisecondsSinceEpoch, // Gerando um ID único
        nome: _nomeController.text,
        sobrenome: _sobrenomeController.text,
        telefone: _telefoneController.text,
        email: _emailController.text,
        foto: _fotoBase64!, // Armazena diretamente o Uint8List
      );

      try {
        await _clienteRepository.addCliente(novoCliente);
        Navigator.pop(context, novoCliente); // Retorna o cliente criado
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar cliente: $e')),
        );
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final base64String = base64Encode(bytes);
      print('Base64 da imagem: $base64String'); // Log para verificar a string Base64
      setState(() {
        _fotoBase64 = base64String;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhuma foto foi selecionada.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Cliente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _sobrenomeController,
                decoration: const InputDecoration(labelText: 'Sobrenome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o sobrenome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _telefoneController,
                decoration: const InputDecoration(labelText: 'Telefone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o telefone';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o email';
                  } else if (!RegExp(r'^[\w-]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Por favor, insira um email válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _pickImage,
                child: _fotoBase64 == null
                    ? const Column(
                  children: [
                    Icon(Icons.camera_alt, size: 50),
                    SizedBox(height: 8),
                    Text('Selecione uma foto'),
                  ],
                )
                    : Image.memory(
                  base64Decode(_fotoBase64!),
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _salvarCliente,
                    child: const Text('Salvar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Voltar sem salvar
                    },
                    child: const Text('Cancelar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
