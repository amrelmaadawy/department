import 'package:equatable/equatable.dart';
import '../../../contracts/domain/entities/contract_entity.dart';

abstract class MyContractsState extends Equatable {
  const MyContractsState();

  @override
  List<Object> get props => [];
}

class MyContractsInitial extends MyContractsState {}

class MyContractsLoading extends MyContractsState {}

class MyContractsLoaded extends MyContractsState {
  final List<ContractEntity> contracts;

  const MyContractsLoaded(this.contracts);

  @override
  List<Object> get props => [contracts];
}

class MyContractsError extends MyContractsState {
  final String message;

  const MyContractsError(this.message);

  @override
  List<Object> get props => [message];
}
