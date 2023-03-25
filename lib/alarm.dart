class alarm{
  int? hours;
  int? min;
  int? id;
  String? title;
  alarm({
    this.id,
    this.hours,
    this.min,
    this.title
  });

      factory alarm.fromJson(Map<String, dynamic> json) => alarm(
        id: json["id"],
        hours: json["hours"],
        min: json["min"],
        title: json["title"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "hours": hours,
        "min": min,
        "title": title,
    };
}