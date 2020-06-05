import 'package:equatable/equatable.dart';

abstract class AuthenticateState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthenticationUninitialised extends AuthenticateState {}

class AuthenticationAuthenticated extends AuthenticateState {}

class AuthenticationUnauthenticated extends AuthenticateState {}

class AuthenticationLoading extends AuthenticateState {}
