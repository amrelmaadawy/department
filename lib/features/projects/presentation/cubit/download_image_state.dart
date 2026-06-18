import 'package:equatable/equatable.dart';

abstract class DownloadImageState extends Equatable {
  const DownloadImageState();

  @override
  List<Object> get props => [];
}

class DownloadImageInitial extends DownloadImageState {}

class DownloadImageLoading extends DownloadImageState {}

class DownloadImageSuccess extends DownloadImageState {
  final String message;

  const DownloadImageSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class DownloadImageError extends DownloadImageState {
  final String message;

  const DownloadImageError({required this.message});

  @override
  List<Object> get props => [message];
}
