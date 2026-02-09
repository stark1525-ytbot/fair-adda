enum MatchStatus { open, full, ongoing, completed, cancelled }

class MatchModel {
  final String id;
  final String title;
  final int entryFee;
  final int prizePool;
  final DateTime time;
  final MatchStatus status;
  // Additional fields for Room ID logic
  final String? roomId;
  final String? roomPassword;

  MatchModel({
    required this.id,
    required this.title,
    required this.entryFee,
    required this.prizePool,
    required this.time,
    required this.status,
    this.roomId,
    this.roomPassword,
  });
  
  // Add fromJson/toJson here
}