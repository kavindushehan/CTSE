class UserLog {

  String? date;
  String? hour;
  String? minute;

  //Receiving Data
  UserLog({this.date,this.hour,this.minute});

  factory UserLog.fromMap(map){
    return UserLog(
      date: map['date'],
      hour: map['hour'],
      minute: map['minute'],
    );
  }

  //Sending Data
  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'hour':hour,
      'minute':minute
    };
  }
}