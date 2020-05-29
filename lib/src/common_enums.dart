enum SessionState {
  loggedIn,
  loggedInAsGuest,
  loggedOut,
  sessionExpired,
  firstTimeAuthenticating,
}

SessionState sessionStatusInit(String value) {
  switch (value) {
    case 'loggedInAsMember': // for ocean reef, legacy
    case 'loggedIn':
      return SessionState.loggedIn;
      break;
    case 'loggedInAsGuest':
      return SessionState.loggedInAsGuest;
      break;
    case 'sessionExpired':
      return SessionState.sessionExpired;
      break;
    case 'firstTimeAuthenticating':
      return SessionState.firstTimeAuthenticating;
      break;
    case 'loggedOut':
    default:
      return SessionState.loggedOut;
      break;
  }
}

String sessionStatusToString(SessionState status) {
  switch (status) {
    case SessionState.loggedIn:
      return 'loggedIn';
      break;
    case SessionState.firstTimeAuthenticating:
      return 'firstTimeAuthenticating';
      break;
    case SessionState.loggedInAsGuest:
      return 'loggedInAsGuest';
      break;
    case SessionState.sessionExpired:
      return 'sessionExpired';
      break;
    case SessionState.loggedOut:
    default:
      return 'loggedOut';
      break;
  }
}

enum MergeDirection {
  append,
  prepend,
  replace,
}

enum AuthentiationMechanism { biometrics, pin, none }

String authMechanismToString(AuthentiationMechanism status) {
  switch (status) {
    case AuthentiationMechanism.biometrics:
      return 'biometrics';
      break;
    case AuthentiationMechanism.pin:
      return 'pin';
      break;
    case AuthentiationMechanism.none:
    default:
      return 'none';
      break;
  }
}

AuthentiationMechanism authMechanismInit(String value) {
  switch (value) {
    case 'biometrics':
      return AuthentiationMechanism.biometrics;
      break;
    case 'pin':
      return AuthentiationMechanism.pin;
      break;
    case 'none':
    default:
      return AuthentiationMechanism.none;
      break;
  }
}
