class Comments{
  int id = 0;
  int userId = 0;
  String content = "";
  String createdAt = "";

  Comments(int id,
      int userId,
      String content,
      String createdAt) {
    this.id = id;
    this.userId = userId;
    this.content = content;
    this.createdAt = createdAt;
  }
}