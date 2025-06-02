import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import '../services/firebase_service.dart';
import '../utils/password_generator.dart';

class PasswordGeneratorPage extends StatefulWidget {
  const PasswordGeneratorPage({super.key});

  @override
  State<PasswordGeneratorPage> createState() => _PasswordGeneratorPageState();
}

class _PasswordGeneratorPageState extends State<PasswordGeneratorPage> {
  int passwordLength = 12;
  bool includeUppercase = true;
  bool includeNumbers = true;
  bool includeSymbols = true;
  String generatedPassword = '';

  void generatePassword() {
    setState(() {
      generatedPassword = PasswordGenerator.generate(
        length: passwordLength,
        hasUppercase: includeUppercase,
        hasNumbers: includeNumbers,
        hasSymbols: includeSymbols,
      );
    });
    FirebaseService.savePassword(generatedPassword);
  }

  Stream<DatabaseEvent> getPasswordHistory() {
    return FirebaseService.getPasswordHistory().onValue;
  }

  Future<void> clearPasswordHistory() async {
    await FirebaseService.clearPasswordHistory();
  }

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Senha copiada!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerador de Senhas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await clearPasswordHistory();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Histórico de senhas limpo!')),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Slider(
              min: 6,
              max: 32,
              divisions: 26,
              label: 'Tamanho: $passwordLength',
              value: passwordLength.toDouble(),
              onChanged: (value) {
                setState(() {
                  passwordLength = value.toInt();
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Incluir letras maiúsculas'),
              value: includeUppercase,
              onChanged: (value) {
                setState(() {
                  includeUppercase = value!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Incluir números'),
              value: includeNumbers,
              onChanged: (value) {
                setState(() {
                  includeNumbers = value!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Incluir símbolos'),
              value: includeSymbols,
              onChanged: (value) {
                setState(() {
                  includeSymbols = value!;
                });
              },
            ),
            ElevatedButton(
              onPressed: generatePassword,
              child: const Text('Gerar Senha'),
            ),
            const SizedBox(height: 20),
            if (generatedPassword.isNotEmpty) ...[
              SelectableText(
                generatedPassword,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                icon: const Icon(Icons.copy),
                label: const Text('Copiar'),
                onPressed: () => copyToClipboard(generatedPassword),
              ),
            ],
            const Divider(),
            const Text(
              'Histórico de Senhas',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: StreamBuilder<DatabaseEvent>(
                stream: getPasswordHistory(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Erro ao carregar histórico.');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                    return const Text('Nenhum histórico ainda.');
                  }

                  final data = Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);
                  final items = data.entries.toList().reversed.toList();

                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index].value as Map;
                      return ListTile(
                        title: Text(
                          item['password'],
                          style: const TextStyle(fontFamily: 'monospace'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
