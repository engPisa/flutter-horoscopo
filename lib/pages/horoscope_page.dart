import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../services/horoscope_service.dart';
import '../services/firebase_service.dart';

class HoroscopePage extends StatefulWidget {
  const HoroscopePage({super.key});

  @override
  State<HoroscopePage> createState() => _HoroscopePageState();
}

class _HoroscopePageState extends State<HoroscopePage> {
  final List<String> signs = [
    'aries', 'touro', 'gemeos', 'cancer',
    'leao', 'virgem', 'libra', 'escorpiao',
    'sagittarius', 'capricornio', 'aquario', 'peixes'
  ];

  String? selectedSign;
  String? horoscope;
  bool isLoading = false;

  Future<void> fetchHoroscopeData(String sign) async {
    setState(() {
      isLoading = true;
      horoscope = null;
    });

    try {
      final result = await HoroscopeService.fetchHoroscope(sign);
      setState(() {
        horoscope = result;
      });
      await FirebaseService.saveHoroscope(sign, result);
    } catch (e) {
      setState(() {
        horoscope = 'Erro ao carregar horóscopo.';
      });
      print('Erro ao carregar horóscopo: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Stream<DatabaseEvent> getHoroscopeHistory() {
    return FirebaseService.getHoroscopeHistory().onValue;
  }

  Future<void> clearHoroscopeHistory() async {
    await FirebaseService.clearHoroscopeHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Horóscopo do Dia'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await clearHoroscopeHistory();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Histórico de horóscopos limpo!')),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Escolha seu signo',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.star),
              ),
              items: signs.map((sign) {
                return DropdownMenuItem<String>(
                  value: sign,
                  child: Text(sign[0].toUpperCase() + sign.substring(1)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  selectedSign = value;
                  fetchHoroscopeData(selectedSign!);
                }
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: isLoading
                  ? const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                ),
              )
                  : horoscope != null
                  ? Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (selectedSign != null)
                        Center(
                          child: Text(
                            selectedSign![0].toUpperCase() + selectedSign!.substring(1),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            horoscope!,
                            style: const TextStyle(
                              fontSize: 18,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  : const Center(
                child: Text(
                  'Selecione um signo para ver o horóscopo.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const Text(
              'Histórico de Horóscopos',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: StreamBuilder<DatabaseEvent>(
                stream: getHoroscopeHistory(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Erro ao carregar histórico.');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                    return const Center(child: Text('Nenhum histórico ainda.'));
                  }

                  final data = Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);
                  final items = data.entries.toList().reversed.toList();

                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index].value as Map;
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          leading: const Icon(Icons.stars, color: Colors.deepPurple),
                          title: Text(item['sign']),
                          subtitle: Text(
                            item['horoscope'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
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
