import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:typing_game/providers/client_state_provider.dart';
import 'package:typing_game/providers/game_state_provider.dart';
import 'package:typing_game/utils/socket_methods.dart';
import 'package:typing_game/widgets/sentence_game.dart';

import '../widgets/game_text_field.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final SocketMethods _socketMethods = SocketMethods();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _socketMethods.updateTimer(context);
    _socketMethods.updateGame(context);
    _socketMethods.gameFinishedListener();
  }

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameStateProvider>(context);
    final clientStateProvider = Provider.of<ClientStateProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Chip(
                label: Text(
                  clientStateProvider.clientState['timer']['msg'].toString(),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                clientStateProvider.clientState['timer']['countDown']
                    .toString(),
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SentenceGame(),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 600,
                ),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: game.gameState['players'].length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Chip(
                              label: Text(
                                game.gameState['players'][index]['nickname'],
                              ),
                            ),
                            Slider(
                              value: (game.gameState['players'][index]
                                      ['currentWordIndex'] /
                                  game.gameState['words'].length),
                              onChanged: (val) {},
                            ),
                          ],
                        ),
                      );
                    }),
              ),
              game.gameState['isJoin']
                  ? ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 600,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              "${game.gameState['id']}",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(
                                  text: game.gameState['id'],
                                ),
                              ).then((_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Copied to clipboard"),
                                  ),
                                );
                              });
                            },
                            icon: Icon(Icons.copy),
                          ),
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: GameTextField(),
      ),
    );
  }
}
