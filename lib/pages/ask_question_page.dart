import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../constants.dart';
import '../models/question.dart';
import '../widgets/async_button.dart';

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
    final form = useMemoized(() => GlobalKey<FormState>(), []);
    final category = useState<String?>(null);
    final title = useTextEditingController();
    final description = useTextEditingController();

    final questions = db.collection('questions');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tanya Help-Desk'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: form,
              autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    validator: (value) {
                      if (value == null || value == '') {
                        return 'Kategori tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: title,
                    decoration: const InputDecoration(
                      labelText: 'Judul',
                    ),
                    validator: (value) {
                      if (value == null || value == '') {
                        return 'Judul tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: description,
                    decoration: const InputDecoration(
                      labelText: 'Deskripsi',
                    ),
                    validator: (value) {
                      if (value == null || value == '') {
                        return 'Deskripsi tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 48),
                  AsyncButton(
                    child: const Text('Ajukan Pertanyaan'),
                    onPressed: () async {
                      if (form.currentState?.validate() != true) return;

                      await questions.add(Question(
                        category: category.value!,
                        title: title.text,
                        description: description.text,
                        authorId: auth.currentUser!.uid,
                        createdAt: DateTime.now(),
                      ).toJson());

                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
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
      ),
    );
  }
}
