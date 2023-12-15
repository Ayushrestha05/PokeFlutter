import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poke_flutter/utils/constants.dart';
import 'package:poke_flutter/utils/extensions/string_extension.dart';
import 'package:poke_flutter/models/poke_model.dart';
import 'package:poke_flutter/views/poke_detail/poke_detail_notifier.dart';
import 'package:poke_flutter/views/poke_detail/widgets/poke_ability_view.dart';
import 'package:poke_flutter/views/poke_detail/widgets/poke_about_view.dart';
import 'package:poke_flutter/views/poke_detail/widgets/poke_evolution_view.dart';
import 'package:poke_flutter/views/poke_detail/widgets/poke_sprite_view.dart';
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
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
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
                    child: CachedNetworkImage(
                        imageUrl: getKPokeImage(widget.pokemon.id.toString()),
                        height: 100,
                        width: 100,
                        errorWidget: (context, url, error) => SizedBox(
                              height: 100,
                              width: 100,
                              child: Center(
                                child: Image.asset(
                                  'assets/pokeball.png',
                                  height: 60,
                                  width: 60,
                                ),
                              ),
                            )),
                  ),
                  Text(
                    widget.pokemon.name.capitalize(),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
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
              length: 5,
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    const TabBar(
                      isScrollable: true,
                      tabs: [
                        Tab(
                          text: 'About',
                        ),
                        Tab(
                          text: 'Stats',
                        ),
                        Tab(
                          text: 'Sprites',
                        ),
                        Tab(
                          text: 'Abilities',
                        ),
                        Tab(
                          text: 'Evolution',
                        )
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
                      PokeAboutView(
                        detail: pokeDetail.detail,
                      ),
                      PokeDetailStatsView(
                        detail: pokeDetail.detail,
                      ),
                      PokeSpriteView(
                        detail: pokeDetail.detail,
                      ),
                      PokeAbilityView(
                        detail: pokeDetail.detail,
                      ),
                      PokeEvolutionView(
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
