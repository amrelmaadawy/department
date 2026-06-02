import 'package:equatable/equatable.dart';
import 'package:apartment/features/packages/domain/entities/finishing_package_entity.dart';

abstract class PackagesState extends Equatable {
  const PackagesState();

  @override
  List<Object> get props => [];
}

class PackagesInitial extends PackagesState {}

class PackagesLoading extends PackagesState {}

class PackagesLoaded extends PackagesState {
  final List<FinishingPackageEntity> packages;

  const PackagesLoaded(this.packages);

  @override
  List<Object> get props => [packages];
}

class PackagesError extends PackagesState {
  final String message;

  const PackagesError(this.message);

  @override
  List<Object> get props => [message];
}
