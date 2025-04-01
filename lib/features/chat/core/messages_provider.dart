import 'package:profind/features/chat/data/datasource/messages_datasource.dart';
import 'package:profind/features/chat/data/datasource/messages_datasource_impl.dart';
import 'package:profind/features/chat/data/repositories/messages_repository_impl.dart';
import 'package:profind/features/chat/domain/repositories/messages_repository.dart';
import 'package:profind/features/chat/domain/usecase/create_chat_usecase.dart';
import 'package:profind/features/chat/domain/usecase/get_chats_usecase.dart';
import 'package:profind/features/chat/domain/usecase/get_messages_usecase.dart';
import 'package:profind/features/chat/domain/usecase/send_message_usecase.dart';
import 'package:provider/provider.dart';

sealed class MessagesInject {
  static final List<Provider> providers = [
    Provider<MessagesDatasource>(
      create: (context) => MessagesDatasourceImpl(),
    ),
    Provider<MessagesRepository>(
      create: (context) => MessagesRepositoryImpl(
          datasource: context.read<MessagesDatasource>()),
    ),
    Provider<CreateChatUsecase>(
      create: (context) => CreateChatUsecase(
        repository: context.read<MessagesRepository>(),
      ),
    ),
    Provider<GetChatsUsecase>(
      create: (context) => GetChatsUsecase(
        repository: context.read<MessagesRepository>(),
      ),
    ),
    Provider<SendMessageUsecase>(
      create: (context) => SendMessageUsecase(
        repository: context.read<MessagesRepository>(),
      ),
    ),
    Provider<GetMessagesUsecase>(
      create: (context) => GetMessagesUsecase(
        repository: context.read<MessagesRepository>(),
      ),
    ),
  ];
}
