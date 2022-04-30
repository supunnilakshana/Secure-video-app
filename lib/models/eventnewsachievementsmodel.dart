class EventNewsAchievementsModel {
  final String id;
  final String title;
  final String context;
  final String addeddate;
  String editeddate;
  final String imageurl;

  EventNewsAchievementsModel(
      {required this.id,
      required this.title,
      required this.context,
      required this.addeddate,
      this.editeddate = "",
      required this.imageurl});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titel': title,
      'context': context,
      'addeddate': addeddate,
      'editeddate': editeddate,
      'imageurl': imageurl
    };
  }

  factory EventNewsAchievementsModel.fromMap(Map<String, dynamic> res) {
    return EventNewsAchievementsModel(
        id: res['id'],
        title: res['titel'],
        context: res['context'],
        addeddate: res['addeddate'],
        editeddate: res['editeddate'],
        imageurl: res['imageurl']);
  }
}
