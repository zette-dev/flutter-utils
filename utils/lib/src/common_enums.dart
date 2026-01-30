enum SessionState {
  loggedIn,
  loggedInAsGuest,
  loggedOut,
  sessionExpired,
  firstTimeAuthenticating,
}

extension SessionStateExt on SessionState {
  static const _fromString = {
    'loggedIn': SessionState.loggedIn,
    'loggedInAsMember': SessionState.loggedIn, // legacy
    'loggedInAsGuest': SessionState.loggedInAsGuest,
    'sessionExpired': SessionState.sessionExpired,
    'firstTimeAuthenticating': SessionState.firstTimeAuthenticating,
    'loggedOut': SessionState.loggedOut,
  };

  static SessionState fromString(String? value) =>
      _fromString[value] ?? SessionState.loggedOut;

  String toJsonString() => name;
}

// Backward compatibility functions
SessionState sessionStatusInit(String? value) =>
    SessionStateExt.fromString(value);

String sessionStatusToString(SessionState? status) =>
    status?.toJsonString() ?? SessionState.loggedOut.toJsonString();

enum MergeDirection { append, prepend, replace }

enum AuthentiationMechanism { biometrics, pin, none }

extension AuthentiationMechanismExt on AuthentiationMechanism {
  static const _fromString = {
    'biometrics': AuthentiationMechanism.biometrics,
    'pin': AuthentiationMechanism.pin,
    'none': AuthentiationMechanism.none,
  };

  static AuthentiationMechanism fromString(String? value) =>
      _fromString[value] ?? AuthentiationMechanism.none;

  String toJsonString() => name;
}

// Backward compatibility functions
String authMechanismToString(AuthentiationMechanism? status) =>
    status?.toJsonString() ?? AuthentiationMechanism.none.toJsonString();

AuthentiationMechanism authMechanismInit(String? value) =>
    AuthentiationMechanismExt.fromString(value);
