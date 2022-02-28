class Emotion {
  Emotion({
    required this.joy,
    required this.mild,
    required this.disgust,
    required this.depressed,
    required this.anger,
  });

  final double joy;
  final double mild;
  final double disgust;
  final double depressed;
  final double anger;

  Emotion.fromJson(Map<String, dynamic> json)
      : joy = json['joy'],
        mild = json['mild'],
        disgust = json['disgust'],
        depressed = json['depressed'],
        anger = json['anger'];

  Map<String, dynamic> toJson() {
    return {
      'joy': joy,
      'mild': mild,
      'disgust': disgust,
      'depressed': depressed,
      'anger': anger,
    };
  }
}
