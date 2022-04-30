class GalleryItemmodel {
  final String id;
  final String title;
  final String addeddate;
  final String imageurl;

  GalleryItemmodel(
      {required this.id,
      required this.title,
      required this.addeddate,
      required this.imageurl});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titel': title,
      'addeddate': addeddate,
      'imageurl': imageurl
    };
  }

  factory GalleryItemmodel.fromMap(Map<String, dynamic> res) {
    return GalleryItemmodel(
        id: res['id'],
        title: res['titel'],
        addeddate: res['addeddate'],
        imageurl: res['imageurl']);
  }
}
