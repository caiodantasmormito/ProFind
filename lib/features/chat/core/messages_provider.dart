import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:profind/features/chat/data/datasource/messages_datasource.dart';
import 'package:profind/features/chat/data/datasource/messages_datasource_impl.dart';
import 'package:profind/features/chat/data/repositories/messages_repository_impl.dart';
import 'package:profind/features/chat/domain/repositories/messages_repository.dart';
import 'package:profind/features/chat/domain/usecase/get_messages_usecase.dart';
import 'package:profind/features/chat/domain/usecase/get_or_create_chat_usecase.dart';
import 'package:profind/features/chat/domain/usecase/send_message_usecase.dart';
import 'package:provider/provider.dart';

sealed class MessagesInject {
  static final List<Provider> providers = [
    Provider<FirebaseFirestore>(
      create: (_) => FirebaseFirestore.instance,
    ),
    Provider<MessagesDatasource>(
      create: (context) => MessagesDatasourceImpl(
        context.read<FirebaseFirestore>(),
      ),
    ),
    Provider<MessagesRepository>(
      create: (context) => MessagesRepositoryImpl(
          datasource: context.read<MessagesDatasource>()),
    ),
    Provider<GetOrCreateChatUsecase>(
      create: (context) => GetOrCreateChatUsecase(
        repository: context.read<MessagesRepository>(),
      ),
    ),
    Provider<GetMessagesUsecase>(
      create: (context) => GetMessagesUsecase(
        repository: context.read<MessagesRepository>(),
      ),
    ),
    Provider<SendMessageUsecase>(
      create: (context) => SendMessageUsecase(
        repository: context.read<MessagesRepository>(),
      ),
    ),
  ];
}
