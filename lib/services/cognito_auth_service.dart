import 'package:amazon_cognito_identity_dart_2/cognito.dart';

import 'token_storage_service.dart';

class CognitoAuthService {
  CognitoAuthService({TokenStorageService? tokenStorage})
    : _tokenStorage = tokenStorage ?? TokenStorageService(),
      _userPool = CognitoUserPool(userPoolId, clientId);

  static const String userPoolId = 'ap-south-1_bPksPhMFo';
  static const String clientId = '1knlj60mu4msdfjnl9gp9keakj';
  static const String region = 'ap-south-1';

  final TokenStorageService _tokenStorage;
  final CognitoUserPool _userPool;

  Future<Map<String, String?>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final cognitoUser = CognitoUser(email, _userPool);
      final authDetails = AuthenticationDetails(
        username: email,
        password: password,
      );
      final session = await cognitoUser.authenticateUser(authDetails);

      final accessToken = session?.accessToken.jwtToken;
      final idToken = session?.idToken.jwtToken;
      final refreshToken = session?.refreshToken?.token;

      if (accessToken == null || accessToken.isEmpty) {
        throw Exception('Login failed. Please try again.');
      }

      await _tokenStorage.saveAccessToken(accessToken);
      if (idToken != null && idToken.isNotEmpty) {
        await _tokenStorage.saveIdToken(idToken);
      }
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await _tokenStorage.saveRefreshToken(refreshToken);
      }

      return {
        'accessToken': accessToken,
        'idToken': idToken,
        'refreshToken': refreshToken,
      };
    } catch (error) {
      throw Exception(_friendlyError(error));
    }
  }

  Future<void> signOut() async {
    try {
      final currentUser = await _userPool.getCurrentUser();
      final session = await currentUser?.getSession();
      if (currentUser != null && session?.isValid() == true) {
        await currentUser.globalSignOut();
      }
    } catch (_) {
      // Local token cleanup must still happen even if Cognito sign out fails.
    } finally {
      await _tokenStorage.clearTokens();
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    String? name,
    String? phoneNumber,
  }) async {
    try {
      final attributes = <AttributeArg>[
        AttributeArg(name: 'email', value: email),
        if (name != null && name.trim().isNotEmpty)
          AttributeArg(name: 'name', value: name.trim()),
        if (phoneNumber != null && phoneNumber.trim().isNotEmpty)
          AttributeArg(name: 'phone_number', value: phoneNumber.trim()),
      ];

      await _userPool.signUp(email, password, userAttributes: attributes);
    } catch (error) {
      throw Exception(_friendlyError(error));
    }
  }

  Future<void> confirmSignUp({
    required String email,
    required String confirmationCode,
  }) async {
    try {
      final cognitoUser = CognitoUser(email, _userPool);
      await cognitoUser.confirmRegistration(confirmationCode);
    } catch (error) {
      throw Exception(_friendlyError(error));
    }
  }

  Future<void> resendSignUpCode({required String email}) async {
    try {
      final cognitoUser = CognitoUser(email, _userPool);
      await cognitoUser.resendConfirmationCode();
    } catch (error) {
      throw Exception(_friendlyError(error));
    }
  }

  Future<void> forgotPassword({required String email}) async {
    try {
      final cognitoUser = CognitoUser(email, _userPool);
      await cognitoUser.forgotPassword();
    } catch (error) {
      throw Exception(_friendlyError(error));
    }
  }

  Future<void> confirmForgotPassword({
    required String email,
    required String confirmationCode,
    required String newPassword,
  }) async {
    try {
      final cognitoUser = CognitoUser(email, _userPool);
      await cognitoUser.confirmPassword(confirmationCode, newPassword);
    } catch (error) {
      throw Exception(_friendlyError(error));
    }
  }

  Future<bool> hasValidStoredToken() async {
    final accessToken = await _tokenStorage.getAccessToken();
    return accessToken != null && accessToken.isNotEmpty;
  }

  Future<String?> getAccessToken() {
    return _tokenStorage.getAccessToken();
  }

  String _friendlyError(dynamic error) {
    final text = error.toString();

    if (text.contains('UserNotFoundException')) {
      return 'Account not found.';
    }
    if (text.contains('NotAuthorizedException')) {
      return 'Incorrect email or password.';
    }
    if (text.contains('UserNotConfirmedException')) {
      return 'Please verify your account before login.';
    }
    if (text.contains('CodeMismatchException')) {
      return 'Invalid verification code.';
    }
    if (text.contains('ExpiredCodeException')) {
      return 'Verification code expired. Please request a new one.';
    }
    if (text.contains('UsernameExistsException')) {
      return 'An account already exists with this email.';
    }
    if (text.contains('InvalidPasswordException')) {
      return 'Password does not meet security requirements.';
    }
    if (text.contains('LimitExceededException')) {
      return 'Too many attempts. Please try again later.';
    }

    final message = _errorMessage(error);
    if (message != null && message.trim().isNotEmpty) {
      return message;
    }

    return 'Something went wrong. Please try again.';
  }

  String? _errorMessage(dynamic error) {
    if (error is CognitoClientException) {
      return error.message;
    }

    try {
      final dynamic possibleMessage = error.message;
      return possibleMessage?.toString();
    } catch (_) {
      return null;
    }
  }
}
