class Pal {
  Pal({
    required this.leftId,
    required this.rightId,
    this.leftAcceptedAt,
    this.rightAcceptedAt,
  });

  final String leftId;
  final String rightId;
  final DateTime? leftAcceptedAt;
  final DateTime? rightAcceptedAt;

  Pal.fromJson(Map<String, dynamic> json)
      : leftId = json['left_id'],
        rightId = json['right_id'],
        leftAcceptedAt = DateTime.parse(json['left_accepted_at']),
        rightAcceptedAt = DateTime.parse(json['right_accepted_at']);

  Map<String, dynamic> toJson() {
    return {
      'left_id': leftId,
      'right_id': rightId,
      'left_accepted_at': leftAcceptedAt,
      'right_accepted_at': rightAcceptedAt,
    };
  }
}
