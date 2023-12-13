import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poke_flutter/extensions/string_extension.dart';
import 'package:poke_flutter/services/api_services.dart';
import 'package:poke_flutter/views/main/poke_data_state.dart';
import 'package:poke_flutter/views/main/poke_notifier.dart';
import 'package:poke_flutter/views/poke_detail/poke_detail_view.dart';
import 'package:poke_flutter/views/poke_detail/poke_selected_notifier.dart';
import 'package:poke_flutter/widgets/poke_type_widget.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final poke = ref.watch(pokeNotifierProvider);
    return Scaffold(
        body: SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverAppBar(
              backgroundColor: Color(0xFFebf3f5),
              snap: true,
              floating: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(0.0)),
              ),
              title: TextField(
                onChanged: ((value) => ref
                    .read(pokeNotifierProvider.notifier)
                    .filterPokeData(value)),
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  filled: true,
                  fillColor: Color(0xFFebf3f5),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (text) {
                  // Handle search query
                },
              ),
            ),
          ),
          if (poke.status == PokeDataStatus.loading) ...[
            const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator())),
          ] else if (poke.status == PokeDataStatus.error) ...[
            Center(child: Text(poke.error!))
          ] else ...[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return InkWell(
                      onTap: () {
                        final int selectedPokeID = poke.pokemons![index].id;
                        ref
                            .read(selectedPokeNotifierProvider.notifier)
                            .setPokeID(selectedPokeID);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return PokeDetailView(
                            pokeID: selectedPokeID,
                          );
                        }));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                children: [
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '#${poke.pokemons![index].id}',
                                      )),
                                  Spacer(),
                                  // Unsure about how to show the types
                                  // Its a sphagetti method to get the types
                                  // Since Search is used to find pokemon and the initial list doesn't contain pokemon types
                                  // I have to call the API again to get the types
                                  // TODO : Find a better way to do this
                                  FutureBuilder(
                                      future: APIService().getPokemonDetail(
                                          poke.pokemons![index].id),
                                      builder: (context, snapshot) {
                                        switch (snapshot.connectionState) {
                                          case ConnectionState.done:
                                            if (snapshot.hasData) {
                                              return Wrap(
                                                spacing: 3,
                                                children: snapshot.data!.types!
                                                    .map<Widget>(
                                                        (e) => pokeTypeSmall(e))
                                                    .toList(),
                                              );
                                            } else {
                                              return SizedBox();
                                            }
                                          default:
                                            return SizedBox();
                                        }
                                      })
                                ],
                              ),
                            ),
                            //TODO Add Placeholder when Error Occurs
                            Image.network(
                              'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${poke.pokemons![index].id}.png',
                              height: 100,
                              width: 100,
                            ),
                            Text(
                              poke.pokemons![index].name.capitalize(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: poke.pokemons!.length,
                ),
              ),
            ),
          ],
        ],
      ),
    ));
  }
}
