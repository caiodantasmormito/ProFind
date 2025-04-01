
import 'package:equatable/equatable.dart';
import 'package:profind/core/domain/failure/failure.dart';



abstract interface class UseCase<Type, Params> {
  Future<(Failure?, Type?)> call(Params params);
}

class NoParams extends Equatable {
  const NoParams();
  @override
  List<Object?> get props => [];
}

abstract class VoidUseCase<Params> {
  Future<(Failure?, void)> call(Params params);
}


abstract class StreamUseCase<ReturnType, Params> {
  Stream<(Failure?, ReturnType)> call(Params params);
}
