class Attendance {
  final int? id;
  final int? attendanceCode;
  final int employeeCode;
  final String? employeeName;
  final DateTime? date;
  final String? inTime;
  final String? outTime;
  final String? status;

  Attendance({
    this.id,
    this.attendanceCode,
    required this.employeeCode,
    this.employeeName,
    this.date,
    this.inTime,
    this.outTime,
    this.status,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'],
      attendanceCode: json['attendanceCode'],
      employeeCode: json['employeeCode'],
      employeeName: json['employeeName'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      inTime: json['inTime'],
      outTime: json['outTime'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attendanceCode': attendanceCode,
      'employeeCode': employeeCode,
      'employeeName': employeeName,
      'date': date?.toIso8601String(),
      'inTime': inTime,
      'outTime': outTime,
      'status': status,
    };
  }
}