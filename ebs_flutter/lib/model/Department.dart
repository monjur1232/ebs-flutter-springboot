class Department {
  final int? id;
  final int? departmentCode;
  final String? departmentName;

  Department({
    this.id,
    this.departmentCode,
    this.departmentName,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'],
      departmentCode: json['departmentCode'],
      departmentName: json['departmentName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'departmentCode': departmentCode,
      'departmentName': departmentName,
    };
  }
}