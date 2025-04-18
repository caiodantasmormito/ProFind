import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profind/features/chat/presentation/bloc/get_user_chats/get_user_chats_bloc.dart';

class ListChatsPage extends StatefulWidget {
  const ListChatsPage({super.key});

  static const String routeName = '/listChats';

  @override
  State<ListChatsPage> createState() => _ListChatsPageState();
}

class _ListChatsPageState extends State<ListChatsPage> {
  @override
  void initState() {
    super.initState();

    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (userId.isNotEmpty) {
      context.read<GetUserChatsBloc>().add(LoadChats(userId: userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text('Minhas Conversas'),
      ),
      body: BlocBuilder<GetUserChatsBloc, GetUserChatsState>(
        builder: (context, state) {
          if (state is GetUserChatsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GetUserChatsError) {
            return Center(child: Text(state.message));
          }

          if (state is GetUserChatsSuccess) {
            final chatsWithMessages = state.chats
                .where((chat) => chat.lastMessage.isNotEmpty)
                .toList();

            if (chatsWithMessages.isEmpty) {
              return const Center(child: Text('Nenhuma conversa encontrada'));
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: chatsWithMessages.length,
              itemBuilder: (context, index) {
                final chat = chatsWithMessages[index];
                final currentUserId =
                    FirebaseAuth.instance.currentUser?.uid ?? '';
                final otherUserId = chat.participants.firstWhere(
                  (id) => id != currentUserId,
                  orElse: () => '',
                );

                return FutureBuilder<String>(
                  future: _getUserName(otherUserId),
                  builder: (context, snapshot) {
                    final userName =
                        snapshot.connectionState == ConnectionState.done
                            ? snapshot.data ?? 'Usuário desconhecido'
                            : 'Carregando...';

                    return Card(
                      color: Colors.white,
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text(
                          userName,
                          style: TextStyle(
                              color: Color(0xFFfa7f3b),
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(chat.lastMessage),
                        trailing:
                            Text(_formatDate(chat.lastMessageTime.toDate())),
                        onTap: () {
                          /*Navigator.push(context, MaterialPageRoute(
                            builder: (_) => ChatScreen(chatId: chat.id),
                          ));*/
                        },
                      ),
                    );
                  },
                );
              },
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  Future<String> _getUserName(String userId) async {
    try {
      var doc = await FirebaseFirestore.instance
          .collection('clients')
          .doc(userId)
          .get();
      if (doc.exists) {
        final data = doc.data();
        if (data != null) {
          final name = data['name'] as String? ?? '';
          final surname = data['surname'] as String? ?? '';
          return name.isNotEmpty || surname.isNotEmpty
              ? '$name $surname'
              : 'Usuário desconhecido';
        }
      }

      doc = await FirebaseFirestore.instance
          .collection('service_providers')
          .doc(userId)
          .get();
      if (doc.exists) {
        final data = doc.data();
        if (data != null) {
          final name = data['name'] as String? ?? '';
          final surname = data['surname'] as String? ?? '';
          return name.isNotEmpty || surname.isNotEmpty
              ? '$name $surname'
              : 'Usuário desconhecido';
        }
      }
    } catch (e) {
      debugPrint("Erro ao buscar nome do usuário: $e");
    }

    return 'Usuário desconhecido';
  }
}
