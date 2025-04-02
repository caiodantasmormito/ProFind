import 'package:flutter/material.dart';

class ListChatsPage extends StatefulWidget {
  const ListChatsPage({super.key});

  static const String routeName = '/listChats';

  @override
  State<ListChatsPage> createState() => _ListChatsPageState();
}

class _ListChatsPageState extends State<ListChatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Container(),
    );
  }
}
