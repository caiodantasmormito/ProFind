import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String providerId;
  final String providerName;

  const ChatScreen({
    super.key,
    required this.providerId,
    required this.providerName,
  });

  static const String routeName = '/chat';
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  String? _chatId;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    try {
      _chatId = await _getOrCreateChatId();
    } catch (e) {
      print('Erro ao inicializar chat: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar conversa')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<String> _getOrCreateChatId() async {
    final clientId = _auth.currentUser?.uid;
    if (clientId == null) throw Exception('Usuário não autenticado');

    final providerId = widget.providerId;

    final query = await _firestore
        .collection('chats')
        .where('participants', arrayContains: clientId)
        .get();

    for (var doc in query.docs) {
      if (doc['participants'].contains(providerId)) {
        return doc.id;
      }
    }

    final newChat = await _firestore.collection('chats').add({
      'participants': [clientId, providerId],
      'lastMessage': '',
      'lastMessageTime': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
    });

    return newChat.id;
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty || _chatId == null) return;

    final message = _messageController.text.trim();
    _messageController.clear();

    try {
      await _firestore.collection('messages/$_chatId/messages').add({
        'senderId': _auth.currentUser!.uid,
        'text': message,
        'timestamp': FieldValue.serverTimestamp(),
        'read': false,
      });

      await _firestore.collection('chats').doc(_chatId).update({
        'lastMessage': message,
        'lastMessageTime': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Erro ao enviar mensagem: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao enviar mensagem')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget.providerName),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _chatId == null
                    ? const Center(child: Text('Erro ao carregar conversa'))
                    : StreamBuilder<QuerySnapshot>(
                        stream: _firestore
                            .collection('messages/$_chatId/messages')
                            .orderBy('timestamp', descending: false)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                                child: Text('Erro: ${snapshot.error}'));
                          }

                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          final messages = snapshot.data!.docs;

                          return ListView.builder(
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final message = messages[index];
                              final isMe =
                                  message['senderId'] == _auth.currentUser?.uid;

                              return Align(
                                alignment: isMe
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 16),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: isMe
                                        ? Colors.blue[100]
                                        : Colors.grey[200],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    message['text'],
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Digite sua mensagem...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    enabled: _chatId != null && !_isLoading,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed:
                      _chatId == null || _isLoading ? null : _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
