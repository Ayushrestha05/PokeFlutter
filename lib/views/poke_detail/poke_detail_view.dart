import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poke_flutter/views/poke_detail/poke_detail_notifier.dart';
import 'package:poke_flutter/views/poke_detail/poke_detail_state.dart';

class PokeDetailView extends ConsumerWidget {
  final int pokeID;
  const PokeDetailView({required this.pokeID, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokeDetail = ref.watch(pokeDetailNotifierProvider);
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (pokeDetail.status == PokeDetailStatus.loading) ...[
              const Center(child: CircularProgressIndicator()),
            ] else if (pokeDetail.status == PokeDetailStatus.error) ...[
              Center(child: Text(pokeDetail.error!))
            ] else ...[
              Text(pokeDetail.detail!.name)
            ],
          ],
        ),
      )),
    );
  }
}
