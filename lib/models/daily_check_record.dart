class DailyCheckRecord {
  final bool hasWatchedContent;
  final bool hasRelapsed;
  final DateTime checkTime;

  DailyCheckRecord({
    required this.hasWatchedContent,
    required this.hasRelapsed,
    required this.checkTime,
  });

  Map<String, dynamic> toJson() => {
        'hasWatchedContent': hasWatchedContent,
        'hasRelapsed': hasRelapsed,
        'checkTime': checkTime.toIso8601String(),
      };

  factory DailyCheckRecord.fromJson(Map<String, dynamic> json) {
    return DailyCheckRecord(
      hasWatchedContent: json['hasWatchedContent'],
      hasRelapsed: json['hasRelapsed'],
      checkTime: DateTime.parse(json['checkTime']),
    );
  }
}