import 'dart:math';

import 'package:treehole/utils/constants.dart';

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

  PercentageEmotion toPercentage() {
    final sum = joy + mild + disgust + depressed + anger;
    final j = (joy / sum) * 100;
    final m = (mild / sum) * 100;
    final d = (disgust / sum) * 100;
    final de = (depressed / sum) * 100;
    final a = 100 - j - m - d - de;
    return PercentageEmotion(
      joy: j,
      mild: m,
      disgust: d,
      depressed: de,
      anger: a,
    );
  }

  String toMaxEmotionEmoji() {
    final maxValue = max(max(max(max(joy, mild), disgust), depressed), anger);
    if (maxValue == joy) return joyEmoji;
    if (maxValue == mild) return mildEmoji;
    if (maxValue == disgust) return disgustEmoji;
    if (maxValue == depressed) return depressedEmoji;
    if (maxValue == anger) return angerEmoji;
    throw Exception('unreachable');
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

class PercentageEmotion {
  PercentageEmotion({
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
}
