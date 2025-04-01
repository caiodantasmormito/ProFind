import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:profind/features/chat/domain/usecase/create_chat_usecase.dart';
import 'package:profind/features/chat/domain/usecase/get_chats_usecase.dart';
import 'package:profind/features/chat/domain/usecase/get_messages_usecase.dart';
import 'package:profind/features/chat/domain/usecase/send_message_usecase.dart';
import 'package:profind/features/chat/presentation/bloc/get_chats/get_chats_bloc.dart';
import 'package:profind/features/chat/presentation/bloc/get_messages/get_messages_bloc.dart';
import 'package:profind/features/chat/presentation/bloc/send_message/send_message_bloc.dart';
import 'package:profind/features/chat/presentation/pages/chat_page.dart';
import 'package:profind/features/client/presentation/pages/client_home_page.dart';

sealed class ChatRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      path: ChatScreen.routeName,
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider<GetMessagesBloc>(
            create: (context) => GetMessagesBloc(
              getMessagesUsecase: context.read<GetMessagesUsecase>(),
            ),
          ),
          BlocProvider<SendMessageBloc>(
            create: (context) => SendMessageBloc(
              sendMessageUsecase: context.read<SendMessageUsecase>(),
            ),
          ),
          BlocProvider<ChatBloc>(
            create: (context) => ChatBloc(
              createChatUsecase: context.read<CreateChatUsecase>(),
              getChatUsecase: context.read<GetChatsUsecase>(),
            ),
          ),
        ],
        child: const ChatScreen(
          providerId: '',
          providerName: '',
        ),
      ),
    ),
    GoRoute(
      path: ClientHomePage.routeName,
      builder: (context, state) => const ClientHomePage(),
    ),
  ];
}
