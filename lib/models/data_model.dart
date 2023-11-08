class DataModel {
  String? id;
  String? title;
  String? description;
  String? createdAtDateTime;
  String? image;
  String? status;

  DataModel(
      {this.id,
      this.title,
      this.description,
      this.createdAtDateTime,
      this.image,
      this.status});

  @override
  String toString() {
    // TODO: implement toString
    return 'id: $id - title: $title - desc: $description - time: $createdAtDateTime - status: $status';
  }
}
