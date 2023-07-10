import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../constants.dart';
import '../../../models/ticket.dart';
import '../../../widgets/async_button.dart';
import '../home_page.dart';

class AskQuestion extends HookConsumerWidget {
  const AskQuestion({super.key});

  final List<String> categories = const [
    'Materi Perkuliahan',
    'Siakad',
    'E-learning',
    'Jadwal Kuliah',
    'Biaya Kuliah',
  ];

  final List<String> types = const [
    'Public',
    'Private',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = useMemoized(() => GlobalKey<FormState>(), []);
    final category = useState<String?>(null);
    final title = useTextEditingController();
    final description = useTextEditingController();
    final type = useState<String?>(null);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tanya Help-Desk'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: form,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      labelText: 'Kategori',
                    ),
                    value: category.value,
                    onChanged: (value) {
                      category.value = value;
                    },
                    validator: (value) {
                      if (value == null || value == '') {
                        return 'Kategori tidak boleh kosong';
                      }
                      return null;
                    },
                    items: [
                      ...categories.map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ),
                      )
                    ],
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
                  const SizedBox(height: 24),
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      labelText: 'Jenis Pertanyaan',
                    ),
                    value: type.value,
                    onChanged: (value) {
                      type.value = value;
                    },
                    validator: (value) {
                      if (value == null || value == '') {
                        return 'Jenis pertanyaan tidak boleh kosong';
                      }
                      return null;
                    },
                    items: [
                      ...types.map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 48),
                  AsyncButton(
                    child: const Text('Ajukan Pertanyaan'),
                    onPressed: () async {
                      if (form.currentState?.validate() != true) return;

                      await tickets.add(Ticket(
                        category: category.value!,
                        title: title.text,
                        description: description.text,
                        authorId: auth.currentUser!.uid,
                        createdAt: DateTime.now(),
                      ));

                      ref.read(pageProvider.notifier).state = 0;
                    },
                  ),
                  const SizedBox(height: 18),
                  OutlinedButton(
                    child: const Text('Clear'),
                    onPressed: () {
                      category.value = null;
                      title.clear();
                      description.clear();
                      type.value = null;
                      form.currentState?.validate();
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
