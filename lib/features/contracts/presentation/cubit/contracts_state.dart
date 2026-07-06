import 'package:equatable/equatable.dart';
import '../../domain/entities/apartment_finishing_order_entity.dart';
import '../../domain/entities/contract_entity.dart';
import '../../domain/entities/contract_signature_status_entity.dart';

abstract class ContractsState extends Equatable {
  const ContractsState();

  @override
  List<Object?> get props => [];
}

class ContractsInitial extends ContractsState {}

class FinishingOrdersLoading extends ContractsState {}

class FinishingOrdersLoaded extends ContractsState {
  final List<ApartmentFinishingOrderRoomEntity> rooms;

  const FinishingOrdersLoaded(this.rooms);

  @override
  List<Object?> get props => [rooms];
}
class BoneContractLoading extends ContractsState {}

class FinishingContractLoading extends ContractsState {}

class BoneContractCreated extends ContractsState {
  final ContractEntity contract;

  const BoneContractCreated(this.contract);

  @override
  List<Object?> get props => [contract];
}

class FinishingContractCreated extends ContractsState {
  final ContractEntity contract;

  const FinishingContractCreated(this.contract);

  @override
  List<Object?> get props => [contract];
}

class ContractsError extends ContractsState {
  final String message;

  const ContractsError(this.message);

  @override
  List<Object?> get props => [message];
}

class ContractPartialSigningFailure extends ContractsState {
  final String contractType;
  final String message;

  const ContractPartialSigningFailure(this.contractType, this.message);

  @override
  List<Object?> get props => [contractType, message];
}

class ContractSigningLoading extends ContractsState {}

class ContractSignedSuccess extends ContractsState {
  final ContractEntity contract;

  const ContractSignedSuccess(this.contract);

  @override
  List<Object?> get props => [contract];
}

class ContractStatusesListLoaded extends ContractsState {
  final List<ContractSignatureStatusEntity> statuses;

  const ContractStatusesListLoaded(this.statuses);

  @override
  List<Object?> get props => [statuses];
}

class ContractSignatureStatusesLoaded extends ContractsState {
  final bool isUnitSigned;
  final bool isFinishingSigned;

  const ContractSignatureStatusesLoaded(this.isUnitSigned, this.isFinishingSigned);

  @override
  List<Object?> get props => [isUnitSigned, isFinishingSigned];
}

class ContractDetailsLoading extends ContractsState {}

class ContractDetailsLoaded extends ContractsState {
  final ContractEntity contract;

  const ContractDetailsLoaded(this.contract);

  @override
  List<Object?> get props => [contract];
}

class SessionExpiredState extends ContractsState {}

class ContractPdfGenerating extends ContractsState {}

class ContractPdfGenerated extends ContractsState {
  final String filePath;
  const ContractPdfGenerated(this.filePath);
  @override
  List<Object?> get props => [filePath];
}

class ContractPdfError extends ContractsState {
  final String message;
  const ContractPdfError(this.message);
  @override
  List<Object?> get props => [message];
}
