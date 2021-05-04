import 'package:chat_online/app/domain/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

import 'chat_controller.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends ModularState<ChatPage, ChatController> {
  //use 'controller' variable to access controller

  @override
  void initState() {
    super.initState();
    controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Chat'),
      ), // AppBar
      body: Column(
        children: <Widget>[
          _buildMessages(),
          _buildInputField(),
        ], // <Widget>[]
      ), //Column
    ); //Scaffold
  }

  Widget _buildInputField() {
    return Container(
      color: Colors.black12,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.all(Radius.circular(30))), //BoxDecoration
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: TextFormField(
                    controller: controller.messageTextController,
                    decoration: InputDecoration(
                        labelText: 'Digite aqui', border: InputBorder.none), // InputDecoration
                    style: TextStyle(fontSize: 18.0),
                  ), // TextFormField
                ), //Observer
              ), //Padding
            ), //Container
            IconButton(icon: Icon(Icons.send), onPressed: () => _sendMessage())
          ],
        ), //Row
      ), //Padding
    ); //Container
  }

  Expanded _buildMessages() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: <Color>[Colors.blue[100], Colors.blue[200]],
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
        )), // LinearGradiente, BoxDecoration
        child: Observer(
          builder: (_) => ListView.builder(
            itemCount: controller.messages.length,
            itemBuilder: (context, index) {
              var message = controller.messages[index];
              return GestureDetector(
                onLongPress: () => controller.user() == message.user
                    ? showRemoveDialog(message)
                    : null,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      color: controller.user() == message.user
                          ? Colors.blue[200]
                          : Colors.gray,
                    ), // BoxDecoration
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: controller.user() == message.user
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          controller.user() == message.user
                              ? _buildUsernameInfo(message)
                              : _buildOthersUserInfo(message),
                          Text(
                            message.message,
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ), //Text
                        ]), // Column
                  ), // Container
                ), // Padding
              ); // GestureDetector
            },
          ), // ListView.builder
        ), // Observer
      ), // Container
    ); // Expanded
  }

  Row _buildOthersUserInfo(Message message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          message.user.userName,
          style: TextStyle(
              color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold), // TextStyle
        ), // Text
        Text(
          formatDate(message.sendDate),
          style: TextStyle(color: Colors.black, fontSize: 13),
        ), // Text
      ],
    ); // Row
  }

  Row _buildUsernameInfo(Message message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          formatDateOwnerUser(message.sendDate),
          style: TextStyle(color: Colors.black, fontSize: 13),
        ), // Text
        Text(
          message.user.userName,
          style: TextStyle(
              color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
        ), // Text
      ],
    ); // Row
  }

  _sendMessage() {
    controller.sendMessage();
    FocusScope.of(context).unfocus();
  }

  String formatDate(DateTime time) {
    final df = new DateFormat('HH:mm - dd/MM/yyyy ');
    return df.format(time);
  }

  String formatDateOwnerUser(DateTime time) {
    final df = new DateFormat('dd/MM/yyyy - HH:mm');
    return df.format(time);
  }

  showRemoveDialog(Message message) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Deseja Excluir?'),
          actions: [
            MaterialButton(
              color: Colors.red,
              onPressed: () => _removeMessage(message),
              child: Text('Sim'),
            ), // MaterialButton
            MaterialButton(
              color: Colors.black12,
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Não'),
            ) // MaterialButton
          ],
        ); // AlertDialog
      },
    );
  }

  _removeMessage(Message message) {
    controller.removeMessage(message);
    Navigator.of(context).pop();
  }
}
