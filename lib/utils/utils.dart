String getDisplayTime(DateTime t) {
  final diff = DateTime.now().difference(t);
  if (diff.compareTo(const Duration(days: 2)) < 0) {
    final h = diff.inHours;
    final m = diff.inMinutes;
    final s = diff.inSeconds;
    return h < 2
        ? m < 2
            ? '${s.toString()} second${s == 1 ? '' : 's'}'
            : '${m.toString()} minutes'
        : '${h.toString()} hours';
  } else {
    final ts = t.toLocal().toString();
    return ts.substring(0, ts.length - 7);
  }
}
