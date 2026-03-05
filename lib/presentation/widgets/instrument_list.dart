import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/audio_provider.dart';
import '../../domain/models/question.dart';

class InstrumentList extends ConsumerWidget {
  const InstrumentList({super.key, required this.question});

  final Question question;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioService = ref.read(audioServiceProvider);
    final instruments = question.choices;

    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              '楽器リスト',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 4),
              itemCount: instruments.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final inst = instruments[index];
                return ListTile(
                  dense: true,
                  title: Text(inst.displayName,
                      style: const TextStyle(fontSize: 15)),
                  trailing: IconButton(
                    icon: const Icon(Icons.volume_up),
                    tooltip: '再生',
                    onPressed: () => audioService.playAsset(inst.soundPath),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
