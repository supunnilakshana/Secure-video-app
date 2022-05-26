class Drivemodel {
  final String id;
  final String extesion;
  final String fileName;
  final String fileUrl;
  final String date;

  Drivemodel(
      {required this.id,
      required this.extesion,
      required this.fileName,
      required this.fileUrl,
      required this.date});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'extesion': extesion,
      'fileName': fileName,
      'fileUrl': fileUrl,
      'date': date
    };
  }

  factory Drivemodel.fromMap(Map<String, dynamic> res) {
    return Drivemodel(
        id: res['id'],
        extesion: res['extesion'],
        fileName: res['fileName'],
        fileUrl: res['fileUrl'],
        date: res['date']);
  }
}
