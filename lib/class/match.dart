class Match {
  int id = 0;
  int user = 0;
  int game = 0;
  int event = 0;
  int caster = 0;
  String team = "";
  String enemy = "";
  String matchlink = "";
  String scheduledFor = "";
  bool isExclusiv = false;
  String infos = "";
  String status = "";
  String stream = "";
  int casterAccepted = 0;

  Match(int id,
      int user,
      int game,
      int event,
      int caster,
      String team,
      String enemy,
      String matchlink,
      String scheduledFor,
      bool isExclusiv,
      String infos,
      String status,
      String stream,
      int casterAccepted,) {
    this.id = id;
    this.user = user;
    this.game = game;
    this.event = event;
    this.caster = caster;
    this.team = team;
    this.enemy = enemy;
    this.matchlink = matchlink;
    this.scheduledFor = scheduledFor;
    this.isExclusiv = isExclusiv;
    this.infos = infos;
    this.status = status;
    this.stream = stream;
    this.casterAccepted = casterAccepted;
  }
}