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
      : joy = json['joy'].toDouble(),
        mild = json['mild'].toDouble(),
        disgust = json['disgust'].toDouble(),
        depressed = json['depressed'].toDouble(),
        anger = json['anger'].toDouble();

  Map<String, dynamic> toJson() {
    return {
      'joy': joy,
      'mild': mild,
      'disgust': disgust,
      'depressed': depressed,
      'anger': anger,
    };
  }

  Emotion operator +(Emotion o) {
    return Emotion(
      joy: joy + o.joy,
      mild: mild + o.mild,
      disgust: disgust + o.disgust,
      depressed: depressed + o.depressed,
      anger: anger + o.anger,
    );
  }

  Emotion operator /(int o) {
    return Emotion(
      joy: joy / o,
      mild: mild / o,
      disgust: disgust / o,
      depressed: depressed / o,
      anger: anger / o,
    );
  }

  Emotion operator *(double o) {
    return Emotion(
      joy: joy * o,
      mild: mild * o,
      disgust: disgust * o,
      depressed: depressed * o,
      anger: anger * o,
    );
  }
}
