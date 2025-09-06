class Designation {
  final int? id;
  final int? designationCode;
  final String? designationName;
  final int? level;

  Designation({
    this.id,
    this.designationCode,
    this.designationName,
    this.level,
  });

  factory Designation.fromJson(Map<String, dynamic> json) {
    return Designation(
      id: json['id'],
      designationCode: json['designationCode'],
      designationName: json['designationName'],
      level: json['level'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'designationCode': designationCode,
      'designationName': designationName,
      'level': level,
    };
  }
}