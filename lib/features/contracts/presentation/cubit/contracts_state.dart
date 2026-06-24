import 'package:equatable/equatable.dart';
import '../../domain/entities/contract_entity.dart';

abstract class ContractsState extends Equatable {
  const ContractsState();

  @override
  List<Object?> get props => [];
}

class ContractsInitial extends ContractsState {}

class ContractsLoading extends ContractsState {}

class BoneContractCreated extends ContractsState {
  final ContractEntity contract;

  const BoneContractCreated(this.contract);

  @override
  List<Object?> get props => [contract];
}

class ContractsError extends ContractsState {
  final String message;

  const ContractsError(this.message);

  @override
  List<Object?> get props => [message];
}

class ContractSigningLoading extends ContractsState {}

class ContractSignedSuccess extends ContractsState {
  final ContractEntity contract;

  const ContractSignedSuccess(this.contract);

  @override
  List<Object?> get props => [contract];
}
