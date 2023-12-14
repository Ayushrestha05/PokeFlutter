import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poke_flutter/utils/extensions/string_extension.dart';
import 'package:poke_flutter/models/poke_model.dart';
import 'package:poke_flutter/views/poke_detail/poke_detail_notifier.dart';
import 'package:poke_flutter/views/poke_detail/poke_detail_state.dart';
import 'package:poke_flutter/views/poke_detail/widgets/poke_stats_view.dart';
import 'package:poke_flutter/widgets/poke_type_widget.dart';

class PokeDetailView extends ConsumerStatefulWidget {
  final PokeModel pokemon;
  const PokeDetailView({required this.pokemon, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PokeDetailViewState();
}

class _PokeDetailViewState extends ConsumerState<PokeDetailView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  @override
  Widget build(BuildContext context) {
    final pokeDetail = ref.watch(pokeDetailNotifierProvider);
    log('${pokeDetail.detail!.name}');
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '#${widget.pokemon.id}',
                    ),
                  ),
                  Hero(
                    tag: 'pokeIMG${widget.pokemon.id}',
                    child: Image.network(
                      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${widget.pokemon.id}.png',
                      height: 100,
                      width: 100,
                    ),
                  ),
                  Text(
                    widget.pokemon.name.capitalize(),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (pokeDetail.detail != null)
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Wrap(
                        spacing: 5,
                        children: pokeDetail.detail!.types
                            .map((e) => pokeTypeWidget(
                                  type: e,
                                  isSmall: false,
                                ))
                            .toList(),
                      )
                    ]),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            // More info container
            Expanded(
                child: DefaultTabController(
              length: 2,
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    TabBar(
                      tabs: [
                        Tab(
                          text: 'About',
                        ),
                        Tab(
                          text: 'Stats',
                        ),
                      ],
                      indicator: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.blueAccent,
                            width: 3,
                          ),
                        ),
                      ),
                      labelColor: Colors.blueAccent,
                      splashFactory: NoSplash.splashFactory,
                      unselectedLabelColor: Colors.black,
                    ),
                    Expanded(
                        child: TabBarView(children: [
                      Container(
                        color: Colors.red,
                      ),
                      PokeDetailStatsView(
                        detail: pokeDetail.detail,
                      )
                    ])),
                  ],
                ),
              ),
            )),
          ],
        ),
      )),
    );
  }
}
