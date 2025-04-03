import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:profind/features/chat/data/datasource/chat_datasource.dart';
import 'package:profind/features/chat/data/datasource/chat_datasource_impl.dart';
import 'package:profind/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:profind/features/chat/domain/repositories/messages_repository.dart';
import 'package:profind/features/chat/domain/usecase/get_messages_usecase.dart';
import 'package:profind/features/chat/domain/usecase/get_or_create_chat_usecase.dart';
import 'package:profind/features/chat/domain/usecase/get_user_chats_usecase.dart';
import 'package:profind/features/chat/domain/usecase/send_message_usecase.dart';
import 'package:provider/provider.dart';

sealed class MessagesInject {
  static final List<Provider> providers = [
    Provider<FirebaseFirestore>(
      create: (_) => FirebaseFirestore.instance,
    ),
    Provider<ChatDatasource>(
      create: (context) => ChatDatasourceImpl(
        context.read<FirebaseFirestore>(),
      ),
    ),
    Provider<ChatRepository>(
      create: (context) =>
          ChatRepositoryImpl(datasource: context.read<ChatDatasource>()),
    ),
    Provider<GetOrCreateChatUsecase>(
      create: (context) => GetOrCreateChatUsecase(
        repository: context.read<ChatRepository>(),
      ),
    ),
    Provider<GetMessagesUsecase>(
      create: (context) => GetMessagesUsecase(
        repository: context.read<ChatRepository>(),
      ),
    ),
    Provider<SendMessageUsecase>(
      create: (context) => SendMessageUsecase(
        repository: context.read<ChatRepository>(),
      ),
    ),
    Provider<GetUserChatsUsecase>(
      create: (context) => GetUserChatsUsecase(
        repository: context.read<ChatRepository>(),
      ),
    ),
  ];
}
