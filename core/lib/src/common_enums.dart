enum SessionState {
  loggedIn,
  loggedInAsGuest,
  loggedOut,
  sessionExpired,
  firstTimeAuthenticating,
}

SessionState sessionStatusInit(String? value) {
  switch (value) {
    case 'loggedInAsMember': // for ocean reef, legacy
    case 'loggedIn':
      return SessionState.loggedIn;
    case 'loggedInAsGuest':
      return SessionState.loggedInAsGuest;
    case 'sessionExpired':
      return SessionState.sessionExpired;
    case 'firstTimeAuthenticating':
      return SessionState.firstTimeAuthenticating;
    case 'loggedOut':
    default:
      return SessionState.loggedOut;
  }
}

String sessionStatusToString(SessionState? status) {
  switch (status) {
    case SessionState.loggedIn:
      return 'loggedIn';
    case SessionState.firstTimeAuthenticating:
      return 'firstTimeAuthenticating';
    case SessionState.loggedInAsGuest:
      return 'loggedInAsGuest';
    case SessionState.sessionExpired:
      return 'sessionExpired';
    case SessionState.loggedOut:
    default:
      return 'loggedOut';
  }
}

enum MergeDirection {
  append,
  prepend,
  replace,
}

enum AuthentiationMechanism { biometrics, pin, none }

String authMechanismToString(AuthentiationMechanism? status) {
  switch (status) {
    case AuthentiationMechanism.biometrics:
      return 'biometrics';
    case AuthentiationMechanism.pin:
      return 'pin';
    case AuthentiationMechanism.none:
    default:
      return 'none';
  }
}

AuthentiationMechanism authMechanismInit(String? value) {
  switch (value) {
    case 'biometrics':
      return AuthentiationMechanism.biometrics;
    case 'pin':
      return AuthentiationMechanism.pin;
    case 'none':
    default:
      return AuthentiationMechanism.none;
  }
}
