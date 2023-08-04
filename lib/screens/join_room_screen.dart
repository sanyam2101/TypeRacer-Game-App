import 'package:flutter/material.dart';
import 'package:typing_game/utils/socket_methods.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_textField.dart';

class JoinRoomScreen extends StatefulWidget {
  const JoinRoomScreen({Key? key}) : super(key: key);

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _gameIdController = TextEditingController();
  final SocketMethods _socketMethods = SocketMethods();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _socketMethods.updateGameListener(context);
    _socketMethods.notCorrectGameListener(context);
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
    _gameIdController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          //for keeping width fix in web mode
          constraints: const BoxConstraints(
            maxWidth: 600,
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Join Room',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.08,
                ),
                CustomTextField(
                  controller: _nameController,
                  hintText: 'Enter your Name',
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                CustomTextField(
                  controller: _gameIdController,
                  hintText: 'Enter Game Id',
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                CustomButton(
                  text: 'Join',
                  onTap: () => _socketMethods.joinGame(
                    _gameIdController.text,
                    _nameController.text,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
