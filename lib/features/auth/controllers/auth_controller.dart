import 'package:flutter_riverpod/flutter_riverpod.dart';

// User Role Enum
enum UserRole { user, staff, owner }

// Auth State
class AuthState {
  final bool isAuthenticated;
  final UserRole userRole;
  final bool isLoading;
  final String? errorMessage;
  final bool requiresPasswordChange; // For new devices/mandatory 30 day cycle

  AuthState({
    this.isAuthenticated = false,
    this.userRole = UserRole.user,
    this.isLoading = false,
    this.errorMessage,
    this.requiresPasswordChange = false,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    UserRole? userRole,
    bool? isLoading,
    String? errorMessage,
    bool? requiresPasswordChange,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userRole: userRole ?? this.userRole,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      requiresPasswordChange: requiresPasswordChange ?? this.requiresPasswordChange,
    );
  }
}

// Controller
class AuthController extends StateNotifier<AuthState> {
  // Inject Repository here
  AuthController() : super(AuthState());

  Future<void> login(String id, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await Future.delayed(const Duration(seconds: 2)); // Mock API delay
      
      // MOCK LOGIC: Check credentials
      if (id == 'admin') {
        state = state.copyWith(isAuthenticated: true, userRole: UserRole.owner, isLoading: false);
      } else if (id.startsWith('STAFF')) {
        state = state.copyWith(isAuthenticated: true, userRole: UserRole.staff, isLoading: false);
      } else {
        // Assume User
        // Perform Device Binding Check here via Repository
        state = state.copyWith(isAuthenticated: true, userRole: UserRole.user, isLoading: false);
      }
      
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: "Login Failed");
    }
  }

  void logout() {
    state = AuthState(); // Reset
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController();
});