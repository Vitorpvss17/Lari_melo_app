import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
  final supabase = Supabase.instance.client;
  final String backgroundUrl =
      "https://ufbvcaxhedzauecrgiwd.supabase.co/storage/v1/object/public/background/background3.jpg";

  final ClienteRepository _clienteRepository =
      ClienteRepository(); // Usando o repositório

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

      // Converte a string Base64 para bytes
      final bytes = base64Decode(_fotoBase64!);

      // Gera um nome único para o arquivo
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

      try {
        // Envia os bytes diretamente para o Supabase Storage
        await supabase.storage
            .from('clientes_fotos') // Nome do bucket
            .uploadBinary(
                fileName, bytes); // Usa uploadBinary para enviar bytes

        // Obtém a URL pública da imagem
        final imageUrl =
            supabase.storage.from('clientes_fotos').getPublicUrl(fileName);

        // Cria o cliente com a URL da imagem
        ClienteModel novoCliente = ClienteModel(
          id: DateTime.now().millisecondsSinceEpoch,
          nome: _nomeController.text,
          sobrenome: _sobrenomeController.text,
          telefone: _telefoneController.text,
          email: _emailController.text,
          foto: imageUrl, // Armazena a URL da imagem
        );

        // Salva o cliente no repositório
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
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final base64String = base64Encode(bytes);
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
        title: const Text(
          'Criar Cliente',
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
                    }
                    /*else if (!RegExp(r'^[\w-]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Por favor, insira um email válido';
                    }*/
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
                      child: const Column(
                        children: [
                          Text('Salvar'),
                          Icon(Icons.add_circle_outline),
                          SizedBox(width: 10),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Voltar sem salvar
                      },
                      child: const Column(
                        children: [
                          Text('Cancelar'),
                          Icon(Icons.cancel_outlined),
                          SizedBox(width: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
