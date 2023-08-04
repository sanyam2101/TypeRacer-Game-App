import 'package:flutter/material.dart';
import 'package:typing_game/providers/game_state_provider.dart';
import 'package:typing_game/utils/socket_client.dart';
import 'package:typing_game/utils/socket_methods.dart';
import 'package:typing_game/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class GameTextField extends StatefulWidget {
  const GameTextField({Key? key}) : super(key: key);

  @override
  State<GameTextField> createState() => _GameTextFieldState();
}

class _GameTextFieldState extends State<GameTextField> {
  final SocketMethods _socketMethods = SocketMethods();
  var playerMe = null;
  bool isBtn = true;
  late GameStateProvider? game;
  final TextEditingController _wordsController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    game = Provider.of<GameStateProvider>(context, listen: false);
    findPlayerMe(game!);
  }

  findPlayerMe(GameStateProvider game) {
    game.gameState['players'].forEach((player) {
      if (player['socketID'] == SocketClient.instance.socket!.id) {
        playerMe = player;
      }
    });
  }

  handleStart(GameStateProvider game) {
    _socketMethods.startTimer(playerMe['_id'], game.gameState['id']);
    setState(() {
      isBtn = false;
    });
  }

  handleTextChange(String value, String gameID){
    var lastChar = value[value.length-1];

    if(lastChar == " "){
      _socketMethods.sendUserInput(value, gameID);
      setState(() {
        _wordsController.text = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameData = Provider.of<GameStateProvider>(context);
    return playerMe['isPartyLeader'] && isBtn
        ? CustomButton(
            text: 'START',
            onTap: () => handleStart(gameData),
          )
        : TextFormField(
      readOnly: gameData.gameState['isJoin'],
      controller: _wordsController,
      onChanged: (val) => handleTextChange(val, gameData.gameState['id']),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.transparent,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        fillColor: const Color(0xffF5F5FA),
        hintText: 'Type Here',
        hintStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
        )
      ),
    );
  }
}
