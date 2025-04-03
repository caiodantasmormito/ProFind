import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:profind/features/chat/domain/usecase/get_messages_usecase.dart';
import 'package:profind/features/chat/domain/usecase/get_or_create_chat_usecase.dart';
import 'package:profind/features/chat/domain/usecase/get_user_chats_usecase.dart';
import 'package:profind/features/chat/domain/usecase/send_message_usecase.dart';
import 'package:profind/features/chat/presentation/bloc/get_messages/get_messages_bloc.dart';
import 'package:profind/features/chat/presentation/bloc/get_or_create_chat/get_or_create_chat_bloc.dart';
import 'package:profind/features/chat/presentation/bloc/get_user_chats/get_user_chats_bloc.dart';
import 'package:profind/features/chat/presentation/bloc/send_message/send_message_bloc.dart';
import 'package:profind/features/chat/presentation/pages/chat_page.dart';
import 'package:profind/features/chat/presentation/pages/list_chats_page.dart';

sealed class ChatRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      path: ChatScreen.routeName,
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider<GetOrCreateChatBloc>(
            create: (context) => GetOrCreateChatBloc(
              getOrCreateChat: context.read<GetOrCreateChatUsecase>(),
              sendMessage: context.read<SendMessageUsecase>(),
              getMessages: context.read<GetMessagesUsecase>(),
            ),
          ),
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
        ],
        child: const ChatScreen(
          providerId: '',
          providerName: '',
        ),
      ),
    ),
    GoRoute(
      path: ListChatsPage.routeName,
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider<GetOrCreateChatBloc>(
            create: (context) => GetOrCreateChatBloc(
              getOrCreateChat: context.read<GetOrCreateChatUsecase>(),
              sendMessage: context.read<SendMessageUsecase>(),
              getMessages: context.read<GetMessagesUsecase>(),
            ),
          ),
          BlocProvider<GetMessagesBloc>(
            create: (context) => GetMessagesBloc(
              getMessagesUsecase: context.read<GetMessagesUsecase>(),
            ),
          ),
          BlocProvider<GetUserChatsBloc>(
            create: (context) => GetUserChatsBloc(
              getUserChatsUsecase: context.read<GetUserChatsUsecase>(),
            ),
          ),
        ],
        child: const ListChatsPage(),
      ),
    ),
  ];
}
