import 'package:profind/features/messages/data/datasource/messages_datasource.dart';
import 'package:profind/features/messages/data/datasource/messages_datasource_impl.dart';
import 'package:profind/features/messages/data/repositories/messages_repository_impl.dart';
import 'package:profind/features/messages/domain/repositories/messages_repository.dart';
import 'package:profind/features/messages/domain/usecase/get_messages_usecase.dart';
import 'package:profind/features/messages/domain/usecase/send_message_usecase.dart';
import 'package:provider/provider.dart';

sealed class MessagesInject {
  static final List<Provider> providers = [
    Provider<MessagesDatasource>(
      create: (context) => MessagesDatasourceImpl(),
    ),
    Provider<MessagesRepository>(
      create: (context) => MessagesRepositoryImpl(
          messagesDataSource: context.read<MessagesDatasource>()),
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
