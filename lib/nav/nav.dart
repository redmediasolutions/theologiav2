import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:theologia_app_1/categorypage/categorypage.dart';
import 'package:theologia_app_1/devotionpage/devotionpage.dart';
import 'package:theologia_app_1/home/home.dart';
import 'package:theologia_app_1/nav/shell.dart';
import 'package:theologia_app_1/searchpage/searchpage.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child){
      return MainShell(child: child);
    },
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          builder: (BuildContext context, GoRouterState state) {
            return const HomeScreen();
          },
        ),
        GoRoute(
          path: '/category',
          name: 'category',
          builder: (BuildContext context, GoRouterState state) {
            return const Categorypage();
          },
        ),
        GoRoute(
          path: '/search',
          name: 'search',
          builder: (BuildContext context, GoRouterState state) {
            return const SearchPage();
          },
        ),
        GoRoute(
          path: '/devotions',
          name: 'devotions',
          builder: (BuildContext context, GoRouterState state) {
            return const Devotionpage();
          },
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (BuildContext context, GoRouterState state) {
            return const HomeScreen();
          },
        ),
      ],
    ),
  ],
);