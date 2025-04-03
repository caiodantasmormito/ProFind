import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profind/features/chat/presentation/bloc/get_chats/get_chats_bloc.dart';
import 'package:profind/features/chat/presentation/bloc/get_messages/get_messages_bloc.dart';
import 'package:profind/features/chat/presentation/bloc/send_message/send_message_bloc.dart';

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
  late final TextEditingController _messageController;
  late final String _currentUserId;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _currentUserId = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ChatBloc(
            getOrCreateChat: context.read(),
            sendMessage: context.read(),
            getMessages: context.read(),
          )..add(InitializeChat(
              clientId: _currentUserId,
              providerId: widget.providerId,
              providerName: widget.providerName,
            )),
        ),
        BlocProvider(
          create: (context) => GetMessagesBloc(
            getMessagesUsecase: context.read(),
          ),
        ),
        BlocProvider(
          create: (context) => SendMessageBloc(
            sendMessageUsecase: context.read(),
          ),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(widget.providerName),
        ),
        body: const _ChatView(),
      ),
    );
  }
}

class _ChatView extends StatelessWidget {
  const _ChatView();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: _MessagesList()),
        const _MessageInput(),
      ],
    );
  }
}

class _MessagesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, GetChatState>(
      listener: (context, chatState) {
        if (chatState is GetChatSuccess && context.mounted) {
          context.read<GetMessagesBloc>().add(
                LoadMessages(chatId: chatState.chatId.toString()),
              );
        }
      },
      builder: (context, chatState) {
        if (chatState is GetChatLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (chatState is GetChatError) {
          return Center(child: Text(chatState.message));
        }

        if (chatState is GetChatSuccess) {
          return BlocBuilder<GetMessagesBloc, GetMessagesState>(
            builder: (context, messagesState) {
              if (messagesState is GetMessagesLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (messagesState is GetMessagesError) {
                return Center(child: Text(messagesState.message));
              }

              if (messagesState is GetMessagesSuccess) {
                return ListView.builder(
                  reverse: true,
                  itemCount: messagesState.messages.length,
                  itemBuilder: (context, index) {
                    final message = messagesState.messages[index];
                    final isMe = message.senderId ==
                        FirebaseAuth.instance.currentUser!.uid;

                    return _MessageBubble(
                      message: message.text,
                      isMe: isMe,
                    );
                  },
                );
              }

              return const Center(child: Text('Nenhuma mensagem encontrada'));
            },
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;

  const _MessageBubble({
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

class _MessageInput extends StatefulWidget {
  const _MessageInput();

  @override
  State<_MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<_MessageInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return BlocBuilder<ChatBloc, GetChatState>(
      builder: (context, chatState) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Digite sua mensagem...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  enabled: chatState is GetChatSuccess,
                ),
              ),
              BlocConsumer<SendMessageBloc, SendMessageState>(
                listener: (context, state) {
                  if (state is SendMessageSuccess) {
                    _controller.clear();
                    if (chatState is GetChatSuccess) {
                      context.read<GetMessagesBloc>().add(
                            LoadMessages(chatId: chatState.chatId.toString()),
                          );
                    }
                  }

                  if (state is SendMessageError && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message.toString())),
                    );
                  }
                },
                builder: (context, sendState) {
                  final isLoading = sendState is SendMessageLoading;
                  final isChatReady = chatState is GetChatSuccess;

                  return IconButton(
                    icon: isLoading
                        ? const CircularProgressIndicator()
                        : const Icon(Icons.send),
                    onPressed: isLoading || !isChatReady
                        ? null
                        : () {
                            if (_controller.text.trim().isEmpty) return;

                            context.read<SendMessageBloc>().add(
                                  SendMessage(
                                    chatId: chatState.chatId.toString(),
                                    text: _controller.text.trim(),
                                    senderId: currentUserId,
                                  ),
                                );
                          },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
