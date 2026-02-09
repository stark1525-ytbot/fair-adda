import 'package:flutter/material.dart';

/// A comprehensive icon utility class for the Fair Adda project
/// Provides consistent icon usage across the entire application
class AppIcons {
  // Navigation Icons
  static const IconData home = Icons.home;
  static const IconData homeFilled = Icons.home_filled;
  static const IconData person = Icons.person;
  static const IconData personFilled = Icons.person_2;
  static const IconData leaderboard = Icons.leaderboard;
  static const IconData help = Icons.help;
  static const IconData helpOutline = Icons.help_outline;
  static const IconData settings = Icons.settings;
  static const IconData settingsOutline = Icons.settings_outlined;
  static const IconData logout = Icons.logout;
  static const IconData menu = Icons.menu;
  static const IconData arrowBack = Icons.arrow_back;
  static const IconData arrowForward = Icons.arrow_forward;
  static const IconData close = Icons.close;

  // Game Related Icons
  static const IconData dice = Icons.casino;
  static const IconData gamepad = Icons.games;
  static const IconData cards = Icons.card_giftcard;
  static const IconData fire = Icons.local_fire_department;
  static const IconData trophy = Icons.emoji_events;
  static const IconData controller = Icons.videogame_asset;
  static const IconData flash = Icons.flash_on;
  static const IconData cut = Icons.cut;
  static const IconData search = Icons.search;
  static const IconData sword = Icons.science;
  static const IconData campaign = Icons.campaign;

  // Finance/Wallet Icons
  static const IconData wallet = Icons.account_balance_wallet;
  static const IconData buildingColumns = Icons.account_balance;
  static const IconData moneyBill = Icons.money;
  static const IconData creditCard = Icons.credit_card;
  static const IconData bank = Icons.account_balance;
  static const IconData history = Icons.history;
  static const IconData deposit = Icons.account_balance;
  static const IconData withdraw = Icons.account_balance;
  static const IconData transaction = Icons.swap_vert;

  // User Actions
  static const IconData edit = Icons.edit;
  static const IconData editOutline = Icons.edit_outlined;
  static const IconData delete = Icons.delete;
  static const IconData add = Icons.add;
  static const IconData addCircle = Icons.add_circle;
  static const IconData remove = Icons.remove;
  static const IconData removeCircle = Icons.remove_circle;
  static const IconData copy = Icons.copy;
  static const IconData share = Icons.share;
  static const IconData notification = Icons.notifications;
  static const IconData notificationOff = Icons.notifications_off;

  // Communication
  static const IconData chat = Icons.chat;
  static const IconData message = Icons.message;
  static const IconData phone = Icons.phone;
  static const IconData email = Icons.email;
  static const IconData mic = Icons.mic;
  static const IconData micOff = Icons.mic_off;
  static const IconData camera = Icons.camera_alt;
  static const IconData videoCam = Icons.videocam;
  static const IconData attachment = Icons.attachment;

  // Status/Indicators
  static const IconData check = Icons.check;
  static const IconData checkCircle = Icons.check_circle;
  static const IconData checkCircleOutline = Icons.check_circle_outline;
  static const IconData error = Icons.error;
  static const IconData errorOutline = Icons.error_outline;
  static const IconData warning = Icons.warning;
  static const IconData info = Icons.info;
  static const IconData infoOutline = Icons.info_outline;
  static const IconData verified = Icons.verified;
  static const IconData shield = Icons.shield;
  static const IconData lock = Icons.lock;
  static const IconData lockOpen = Icons.lock_open;

  // Social/Referral
  static const IconData users = Icons.group;
  static const IconData userPlus = Icons.person_add;
  static const IconData gift = Icons.card_giftcard;
  static const IconData medal = Icons.emoji_events;
  static const IconData star = Icons.star;
  static const IconData starHalf = Icons.star_half;
  static const IconData starOutline = Icons.star_border;

  // Time/Calendar
  static const IconData calendar = Icons.calendar_today;
  static const IconData clock = Icons.access_time;
  static const IconData timer = Icons.timer;
  static const IconData schedule = Icons.schedule;

  // Miscellaneous
  static const IconData gear = Icons.settings;
  static const IconData tools = Icons.build;
  static const IconData document = Icons.description;
  static const IconData download = Icons.download;
  static const IconData upload = Icons.upload;
  static const IconData eye = Icons.visibility;
  static const IconData eyeOff = Icons.visibility_off;
  static const IconData refresh = Icons.refresh;
  static const IconData sync = Icons.sync;
  static const IconData more = Icons.more_vert;
  static const IconData heart = Icons.favorite;
  static const IconData heartOutline = Icons.favorite_border;
  static const IconData bullhorn = Icons.campaign;

  /// Get appropriate icon for different game types
  static IconData getGameIcon(String gameName) {
    final String normalizedGame = gameName.toLowerCase();

    if (normalizedGame.contains('ludo')) {
      return dice;
    } else if (normalizedGame.contains('rummy')) {
      return cards;
    } else if (normalizedGame.contains('call') &&
        normalizedGame.contains('break')) {
      return cards;
    } else if (normalizedGame.contains('free') &&
        normalizedGame.contains('fire')) {
      return fire;
    } else if (normalizedGame.contains('pubg') ||
        normalizedGame.contains('bgmi')) {
      return controller;
    } else if (normalizedGame.contains('tournament')) {
      return trophy;
    } else {
      return gamepad;
    }
  }

  /// Get appropriate icon for different query types
  static IconData getQueryIcon(String queryType) {
    final String normalizedQuery = queryType.toLowerCase();

    if (normalizedQuery.contains('deposit')) {
      return deposit;
    } else if (normalizedQuery.contains('withdraw')) {
      return withdraw;
    } else if (normalizedQuery.contains('kyc')) {
      return shield;
    } else if (normalizedQuery.contains('tournament')) {
      return trophy;
    } else if (normalizedQuery.contains('mech')) {
      return gear;
    } else if (normalizedQuery.contains('word')) {
      return search;
    } else if (normalizedQuery.contains('clash')) {
      return sword;
    } else {
      return help;
    }
  }

  /// Build an icon with consistent styling
  static Widget buildIcon(
    IconData icon, {
    Color? color,
    double size = 24,
    Color? backgroundColor,
    double backgroundPadding = 8,
    double backgroundRadius = 8,
  }) {
    if (backgroundColor != null) {
      return Container(
        padding: EdgeInsets.all(backgroundPadding),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(backgroundRadius),
        ),
        child: Icon(
          icon,
          color: color,
          size: size,
        ),
      );
    }

    return Icon(
      icon,
      color: color,
      size: size,
    );
  }
}
