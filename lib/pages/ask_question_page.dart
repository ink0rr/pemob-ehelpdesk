import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AskQuestionPage extends HookWidget {
  const AskQuestionPage({super.key});

  final List<String> categories = const [
    'Materi Perkuliahan',
    'Siakad',
    'E-learning',
    'Jadwal Kuliah',
    'Biaya Kuliah',
  ];

  @override
  Widget build(BuildContext context) {
    final category = useState<String?>(null);
    final title = useTextEditingController();
    final description = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tanya Help-Desk'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                    labelText: 'Kategori',
                  ),
                  items: categories
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (value) {
                    category.value = value;
                  },
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: title,
                  decoration: const InputDecoration(
                    labelText: 'Judul',
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: description,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi',
                  ),
                ),
                const SizedBox(height: 48),
                ElevatedButton(
                  child: const Text('Ajukan Pertanyaan'),
                  onPressed: () {},
                ),
                const SizedBox(height: 18),
                OutlinedButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
