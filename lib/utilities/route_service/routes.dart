import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tycho_streams/utilities/route_service/routes_name.dart';
import 'package:tycho_streams/view/screens/bottom_navigation.dart';
import 'package:tycho_streams/view/screens/edit_profile.dart';
import 'package:tycho_streams/view/screens/forgot_password.dart';
import 'package:tycho_streams/view/screens/login_screen.dart';
import 'package:tycho_streams/view/screens/register_screen.dart';
import 'package:tycho_streams/view/screens/reset_screen.dart';
import 'package:tycho_streams/view/screens/splash_screen.dart';
import 'package:tycho_streams/view/screens/terms_condition_screen.dart';
import 'package:tycho_streams/view/screens/verify_otp_screen.dart';
import 'package:tycho_streams/viewmodel/profile_view_model.dart';

class MyAppRouter {
  GoRouter router = GoRouter(
    routes: [
      GoRoute(
        name: RoutesName.splash,
        path: '/',
        pageBuilder: (context, state) {
          return MaterialPage(child: SplashScreen());
        },
      ),
      GoRoute(
        name: RoutesName.login,
        path: '/login_page',
        pageBuilder: (context, state) {
          return MaterialPage(child: LoginScreen());
        },
        routes: [
          GoRoute(
            name: RoutesName.register,
            path: 'register_page',
            pageBuilder: (context, state) {
              return MaterialPage(child: RegisterScreen());
            },
          ),
          GoRoute(
            name: RoutesName.reset_password,
            path: 'reset_password/:phone',
            pageBuilder: (context, state) {
              return MaterialPage(
                  child: ResetPassword(phone: state.params['phone']!));
            },
          ),
          GoRoute(
            name: RoutesName.verifyOtp,
            path: 'verify_otp/:phone/:name/:email/:password',
            pageBuilder: (context, state) {
              return MaterialPage(child: VerifyOtp(
                mobileNo: state.params['phone']!,
                name: state.params['name']!,
                email: state.params['email']!,
                password: state.params['password']!,
              ));
            },
          ),
          GoRoute(
            name: RoutesName.forgot,
            path: 'forgot_password',
            pageBuilder: (context, state) {
              return MaterialPage(child: ForgotPassword());
            },
          ),
        ],
      ),
      GoRoute(
        name: RoutesName.bottomNavigation,
        path: '/bottom_navigation',
        pageBuilder: (context, state) {
          return MaterialPage(
              child: BottomNavigation(
            index: 0,
          ));
        },
      ),
      GoRoute(
        name: RoutesName.editProfile,
        path: '/edit_profile',
        pageBuilder: (context, state) {
          return MaterialPage(
              child: EditProfile(viewmodel: state.extra as ProfileViewModel));
        },
      ),
      GoRoute(
        name: RoutesName.privacyTerms,
        path: '/privacy_terms/:title/:description',
        pageBuilder: (context, state) {
          return MaterialPage(
              child: TermsAndConditionsPage(
            title: state.params['title']!,
            description: state.params['description']!,
          ));
        },
      ),
    ],
    errorPageBuilder: (context, state) {
      return MaterialPage(
          child: Center(
        child: Text('Error..\n No Page Found'),
      ));
    },
  );
}
