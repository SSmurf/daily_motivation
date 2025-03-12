class NotificationTime {
  final int hour;
  final int minute;

  const NotificationTime({required this.hour, required this.minute});

  factory NotificationTime.fromJson(Map<String, dynamic> json) {
    return NotificationTime(hour: json['hour'] as int, minute: json['minute'] as int);
  }

  Map<String, dynamic> toJson() {
    return {'hour': hour, 'minute': minute};
  }

  @override
  String toString() => '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}
