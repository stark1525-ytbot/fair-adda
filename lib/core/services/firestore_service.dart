import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  static FirebaseFirestore get _db => FirebaseFirestore.instance;

  static Stream<List<Map<String, dynamic>>> streamCollection(
    String path, {
    String? orderBy,
    bool descending = false,
    int? limit,
  }) {
    Query<Map<String, dynamic>> query = _db.collection(path);
    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: descending);
    }
    if (limit != null) {
      query = query.limit(limit);
    }
    return query.snapshots().map((snap) {
      return snap.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();
    });
  }

  static Stream<List<Map<String, dynamic>>> streamTournamentsByGame(
    String gameName,
  ) {
    return _db
        .collection('tournaments')
        .where('gameName', isEqualTo: gameName)
        .snapshots()
        .map((snap) {
      return snap.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();
    });
  }

  static Stream<List<Map<String, dynamic>>> streamLeagues() {
    return _db.collection('leagues').snapshots().map((snap) {
      return snap.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();
    });
  }

  static Stream<Map<String, dynamic>?> streamLeagueById(String leagueId) {
    return _db.collection('leagues').doc(leagueId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return {'id': doc.id, ...doc.data() as Map<String, dynamic>};
    });
  }

  static Stream<List<Map<String, dynamic>>> streamTournamentsByLeague(
    String leagueId,
  ) {
    return _db
        .collection('tournaments')
        .where('leagueId', isEqualTo: leagueId)
        .snapshots()
        .map((snap) {
      return snap.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();
    });
  }

  static Stream<List<Map<String, dynamic>>> streamMatches({
    bool? isResult,
  }) {
    Query<Map<String, dynamic>> query = _db.collection('matches');
    if (isResult != null) {
      query = query.where('isResult', isEqualTo: isResult);
    }
    return query.snapshots().map((snap) {
      return snap.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();
    });
  }

  static Stream<List<Map<String, dynamic>>> streamUserLeagues(
    String userId,
  ) {
    return _db
        .collection('user_leagues')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .asyncMap((snap) async {
      final leagueIds = snap.docs.map((d) => d['leagueId'] as String).toList();
      if (leagueIds.isEmpty) return <Map<String, dynamic>>[];
      final leagues = await _db
          .collection('leagues')
          .where(FieldPath.documentId, whereIn: leagueIds)
          .get();
      return leagues.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();
    });
  }

  static Color parseColor(dynamic value, {Color fallback = Colors.black}) {
    if (value == null) return fallback;
    if (value is int) return Color(value);
    if (value is String) {
      final cleaned = value.replaceAll('#', '').trim();
      if (cleaned.length == 6) {
        return Color(int.parse('FF$cleaned', radix: 16));
      }
      if (cleaned.length == 8) {
        return Color(int.parse(cleaned, radix: 16));
      }
    }
    return fallback;
  }
}
