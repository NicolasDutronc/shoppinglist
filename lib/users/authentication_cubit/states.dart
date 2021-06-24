import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class Authenticated extends AuthenticationState {}

class Authenticating extends AuthenticationState {}

class Unauthenticated extends AuthenticationState {
  final Exception error;

  const Unauthenticated({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => "Authentication failure { error: $error }";
}
