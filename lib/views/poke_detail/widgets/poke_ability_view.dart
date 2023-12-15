import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poke_flutter/models/poke_detail_model.dart';
import 'package:poke_flutter/utils/extensions/string_extension.dart';
import 'package:poke_flutter/utils/services/api_notifier.dart';
import 'package:poke_flutter/utils/services/api_services.dart';

class PokeAbilityView extends StatelessWidget {
  final PokeDetailModel? detail;
  const PokeAbilityView({super.key, this.detail});

  @override
  Widget build(BuildContext context) {
    return detail != null
        ? Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
                itemCount: detail!.abilities.length,
                itemBuilder: (ctx, i) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          detail!.abilities[i].name.toString().capitalize(),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        Consumer(
                          builder: (context, ref, child) {
                            final apiProvider = ref.read(apiNotifierProvider);
                            return FutureBuilder(
                                future: apiProvider.getPokeAbilityDesc(
                                    detail!.abilities[i].url.toString()),
                                builder: (ctx, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        snapshot.data.toString(),
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 12),
                                      ),
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
                                });
                          },
                        ),
                        Divider()
                      ],
                    )),
          )
        : Container();
  }
}
