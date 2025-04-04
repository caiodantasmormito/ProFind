import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:profind/features/profile/data/datasource/profile_datasource.dart';
import 'package:profind/features/profile/data/datasource/profile_datasource_impl.dart';
import 'package:profind/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:profind/features/profile/domain/repositories/profile_repository.dart';
import 'package:profind/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:profind/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:profind/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:provider/provider.dart';

sealed class ProfileInject {
  static final List<Provider> providers = [
    Provider<ProfileDataSource>(
      create: (context) => ProfileDataSourceImpl(
        auth: FirebaseAuth.instance,
        firestore: FirebaseFirestore.instance,
      ),
    ),
    Provider<ProfileRepository>(
      create: (context) => ProfileRepositoryImpl(
        dataSource: context.read<ProfileDataSource>(),
      ),
    ),
    Provider<GetProfileUsecase>(
      create: (context) => GetProfileUsecase(
        repository: context.read<ProfileRepository>(),
      ),
    ),
    Provider<UpdateProfileUsecase>(
      create: (context) => UpdateProfileUsecase(
        repository: context.read<ProfileRepository>(),
      ),
    ),
    Provider<ProfileBloc>(
      create: (context) => ProfileBloc(
        auth: FirebaseAuth.instance,
        firestore: FirebaseFirestore.instance,
      ),
    ),
  ];
}
