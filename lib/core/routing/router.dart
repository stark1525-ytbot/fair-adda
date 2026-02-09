import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod/riverpod.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/signup_screen.dart';
import '../../features/auth/presentation/otp_screen.dart';
import '../../features/match_management/presentation/match_list_screen.dart';
import '../../features/match_management/presentation/esports_games_screen.dart';
import '../../features/match_management/presentation/esports_tournament_screen.dart';
import '../../features/match_management/presentation/tournament_detail_screen.dart';
import '../../features/scratch/scrach_card.dart';
import '../../features/reward/reward.dart';
// import '../../features/help/help_screen.dart';
import '../../features/quizes/quiz.dart';
import '../../features/deposit_limit/deposit_limit_screen.dart';
import '../../features/statistics/statistics_screen.dart';
import '../../features/tds/tds_certificate_screen.dart';
import '../../features/referrals/referrals_screen.dart';
import '../../features/responsible_gaming/responsible_gaming_screen.dart';
import '../../features/tutorial/tutorial_screen.dart';
import '../../features/wallet/presentation/wallet_screen.dart';
import '../../features/wallet/presentation/add_money_screen.dart';
import '../../features/wallet/presentation/withdraw_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/match_management/presentation/match_details_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/leaderboard/presentation/leaderboard_screen.dart';
import '../../features/staff_management/presentation/owner_users_list_screen.dart';
import '../../features/dashboard/presentation/user_dashboard.dart';
import '../../features/dashboard/presentation/staff_dashboard.dart';
import '../../features/dashboard/presentation/owner_dashboard.dart';
import '../../features/league/presentation/my_league_screen.dart';
import '../../features/league/presentation/league_detail_screen.dart';
import '../../features/spin_and_win/presentation/spin_and_win_screen.dart';
import '../../features/settings/presentation/settings_detail_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/otp',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final phoneNumber = (extra['phoneNumber'] ?? '') as String;
          final verificationId = (extra['verificationId'] ?? '') as String;
          return OtpScreen(
            phoneNumber: phoneNumber,
            verificationId: verificationId,
          );
        },
      ),

      // User Routes
      GoRoute(
        path: '/user',
        builder: (context, state) => const UserDashboard(),
      ),
      GoRoute(
        path: '/user/matches',
        builder: (context, state) => const MatchListScreen(),
      ),
      GoRoute(
        path: '/user/wallet',
        builder: (context, state) => const WalletScreen(),
      ),
      GoRoute(
        path: '/user/scratch',
        builder: (context, state) => const ScratchCardsScreen(),
      ),
      GoRoute(
        path: '/user/rewards',
        builder: (context, state) => const RewardsScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/add_money',
        builder: (context, state) => const AddMoneyScreen(),
      ),
      GoRoute(
        path: '/withdraw',
        builder: (context, state) => const WithdrawScreen(),
      ),
      GoRoute(
        path: '/redeem-voucher',
        builder: (context, state) => const WalletScreen(),
      ),
      GoRoute(
        path: '/payment-history',
        builder: (context, state) => const MatchListScreen(),
      ),
      GoRoute(
        path: '/stats',
        builder: (context, state) => const StatisticsScreen(),
      ),
      GoRoute(
        path: '/kyc',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/tds',
        builder: (context, state) => const TdsCertificateScreen(),
      ),
      GoRoute(
        path: '/quiz',
        builder: (context, state) => const QuizzesScreen(),
      ),
      GoRoute(
        path: '/referrals',
        builder: (context, state) => const ReferralsScreen(),
      ),
      GoRoute(
        path: '/deposit-limit',
        builder: (context, state) => const DepositLimitScreen(),
      ),
      GoRoute(
        path: '/responsible-gaming',
        builder: (context, state) => const ResponsibleGamingScreen(),
      ),
      GoRoute(
        path: '/tutorial',
        builder: (context, state) => const TutorialScreen(),
      ),
      GoRoute(
        path: '/logout',
        builder: (context, state) =>
            const SplashScreen(), // Navigate to splash/login
      ),

      // Esports Routes
      GoRoute(
        path: '/esports/games',
        builder: (context, state) => const EsportsGamesScreen(),
      ),
      GoRoute(
        path: '/esports/:game/tournaments',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final gameName = (extra?['gameName'] ??
                  state.pathParameters['game']?.replaceAll('_', ' ') ??
                  '')
              .toString();
          return EsportsTournamentScreen(gameName: gameName);
        },
      ),
      GoRoute(
        path: '/tournament/:id',
        builder: (context, state) => TournamentDetailScreen(
          tournamentId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/leagues',
        builder: (context, state) => const MyLeaguesScreen(),
      ),
      GoRoute(
        path: '/my-leagues',
        builder: (context, state) => const MyLeaguesScreen(),
      ),
      GoRoute(
        path: '/league/:id',
        builder: (context, state) => LeagueDetailScreen(
          leagueId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/match/:id',
        builder: (context, state) => MatchDetailsScreen(
          matchId: state.pathParameters['id']!,
        ),
      ),

      // Staff Dashboard
      GoRoute(
        path: '/staff',
        builder: (context, state) => const StaffDashboard(),
      ),

      // Owner Dashboard
      GoRoute(
        path: '/owner',
        builder: (context, state) => const OwnerDashboard(),
      ),
      GoRoute(
        path: '/owner/users',
        builder: (context, state) => const OwnerUsersListScreen(),
      ),

      // Standalone Screens
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/settings/:page',
        builder: (context, state) => SettingsDetailScreen(
          title: state.pathParameters['page'] ?? 'Settings',
        ),
      ),
      GoRoute(
        path: '/leaderboard',
        builder: (context, state) => const LeaderboardScreen(),
      ),
      GoRoute(
        path: '/rewards',
        builder: (context, state) => const RewardsScreen(),
      ),
      GoRoute(
        path: '/help',
        builder: (context, state) =>
            Scaffold(body: Center(child: Text("Help Screen Missing"))),
      ),
      GoRoute(
        path: '/spin-and-win',
        builder: (context, state) => const SpinAndWinScreen(),
      ),
    ],

    // Error page handler
    errorBuilder: (context, state) => const Scaffold(
      body: Center(
        child: Text('Page not found'),
      ),
    ),
  );
});
