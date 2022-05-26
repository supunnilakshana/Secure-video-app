class Keymodel {
  final String id;
  final String key;
  final String type;
  final String addeddate;

  Keymodel({
    required this.id,
    required this.key,
    this.type = ".mp4",
    required this.addeddate,
  });
  Map<String, dynamic> toMap() {
    return {'id': id, 'key': key, 'addeddate': addeddate, 'type': type};
  }

  factory Keymodel.fromMap(Map<String, dynamic> res) {
    return Keymodel(
      id: res['id'],
      key: res['key'],
      type: res['type'] ?? ".mp4",
      addeddate: res['addeddate'],
    );
  }
}
