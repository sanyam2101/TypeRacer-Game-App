import 'package:flutter/material.dart';
import 'package:typing_game/utils/socket_client.dart';
import 'package:typing_game/utils/socket_methods.dart';
import 'package:typing_game/widgets/custom_button.dart';
import 'package:typing_game/widgets/custom_textField.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({Key? key}) : super(key: key);

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final TextEditingController _nameController = TextEditingController();
  final SocketClient _socketClient = SocketClient.instance;
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
  }

  // testing(){
  //   _socketClient.socket!.emit('test', 'This is working');
  // }

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
                  'Create Room',
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
                  height: size.height * 0.02,
                ),
                CustomButton(
                  text: 'Create',
                  onTap: () => _socketMethods.createGame(_nameController.text),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
