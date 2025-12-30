import 'package:equatable/equatable.dart';

enum FailureType { server, client, network, unknown }

abstract class Failure extends Equatable {
  final String message;
  final FailureType type;

  const Failure(this.message, this.type);

  @override
  List<Object> get props => [message, type];
}

class ServerFailure extends Failure {
  const ServerFailure([String message = "Server error"])
    : super(message, FailureType.server);
}

class ClientFailure extends Failure {
  final int statusCode;

  const ClientFailure(String s, {
    required this.statusCode,
    String message = "Client error",
  }) : super(message, FailureType.client);

  @override
  List<Object> get props => [...super.props, statusCode];
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = "No internet connection"])
    : super(message, FailureType.network);
}

class UnknownFailure extends Failure {
  const UnknownFailure([String message = "Unexpected error"])
    : super(message, FailureType.unknown);
}
