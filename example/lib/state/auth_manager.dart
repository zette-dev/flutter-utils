import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:dropsource_utils/dropsource_utils.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../data/models/user.dart';
import '../data/services/company_web_service.dart';

class AuthModel extends NetworkingModel {
  AuthModel({
    this.sessionState,
    this.user,
    bool isInProgress,
    dynamic error,
    bool isConnectedToNetwork,
  }) : super(
          isConnectedToNetwork: isConnectedToNetwork,
          isInProgress: isInProgress,
          error: error,
        );

  final SessionState sessionState;
  final User user;

  @override
  String get errorMessage {
    if (error is PlatformException) {
      return error.message;
    }

    return 'Unknown Failure';
  }

  AuthModel _copyWith({
    User user,
    SessionState sessionState,
    bool isInProgress,
    int expiration,
    AuthentiationMechanism authenticationMechanism,
    dynamic error,
  }) =>
      AuthModel(
        user: user ?? this.user,
        sessionState: sessionState ?? this.sessionState,
        isInProgress: isInProgress ?? this.isInProgress,
        error: error ?? this.error,
      );

  // In case you want to serialize
  dynamic toJson() => {};

  factory AuthModel.fromJson(dynamic json) => AuthModel(
        sessionState: sessionStatusInit(json['session_state']),
        isInProgress: false,
      );

  // Model Transformers
  // TODO: implement any model transformations needed.
  // This approach is great because every model defines their own mutations.
  // These can very easily be unit tested to ensure all transformations work.
  // In general, your UI's should be able to be modeled based on these data models

  AuthModel setUser(User user) => _copyWith(user: user);

  AuthModel userSignedIn({User user}) => _copyWith(
        sessionState: SessionState.loggedIn,
      ).setUser(user).resetError();

  AuthModel logOut() => _copyWith(
        sessionState: SessionState.loggedOut,
        authenticationMechanism: AuthentiationMechanism.none,
      ).stopLoading().resetError();

  AuthModel lockOut() => _copyWith(
        sessionState: SessionState.sessionExpired,
      ).stopLoading().resetError();

  AuthModel failedLogin(dynamic err) =>
      _copyWith(sessionState: SessionState.loggedOut).toError(err);
}

class AuthManager extends DataStreamManager<MyCompanyWebService, AuthModel> {
  AuthManager({MyCompanyWebService api, AuthModel model})
      : super(api, model, streams: [
          api.userSream,
        ]);

  @override
  void streamsUpdated(dynamic data) {
    if (data is User) {
      model = model.setUser(data);
    }
  }

  Future signUpUser({String email, String password}) {
    update(model.startLoading());
    return api.signInUser(email: email, password: password).then((user) {
      model = model.userSignedIn(user: user);
    }).catchError((err) {
      model = model.toError(err);
    }).whenComplete(() => update(model.stopLoading()));
  }
}
