import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dropsource_utils/dropsource_utils.dart';

import '../models/user.dart';

class MyCompanyWebService extends WebService {
  MyCompanyWebService(String baseUrl)
      : super(Dio(BaseOptions(baseUrl: baseUrl)));
  String _authToken;

  final _userStreamController = StreamController<User>.broadcast();
  Stream<User> get userSream => _userStreamController.stream;

  User _user;
  set user(User user) {
    _user = user;
    _userStreamController.add(user);
  }
  User get user => _user;

  Future<User> signInUser({String email, String password}) async {
    final request = HTTPRequest(
      method: HTTPRequestMethod.POST,
      path: '/sign-in',
      body: {
        'email': email,
        'password': password,
      },
      authenticated: true,
      autoRefreshToken: true,
    );

    return await request
        .execute(
      client,
      refreshAuth: refreshAuth,
      refreshStatusCode: 401, // set http token to refresh on
    )
        .then((response) async {
      if (response.statusCode == 200) {
        _authToken = response.data['token'];
        user = User.fromJson(response.data['user']);
        //TODO: Do something on success
        return user;
      } else {
        // TODO: handle API Error
      }
    });
  }

  // Automatically refresh auth when receives 401
  Future refreshAuth() async {
    // refresh and set your token;
  }

  // Automatically intercepts every request to allow you to add common headers, etc
  @override
  dynamic onRequestInterceptor(RequestOptions options) {
    options.headers['X-App-Version'] = '1.0';
    return options;
  }

  // Whenever a request is flagged as needing authentication, add proper auth tokens here
  @override
  dynamic authorizationInterceptor(RequestOptions options) {
    if (_authToken != null && _authToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $_authToken';
      options.headers['Content-Type'] = ContentType.json.toString();
    }

    return options;
  }
}
