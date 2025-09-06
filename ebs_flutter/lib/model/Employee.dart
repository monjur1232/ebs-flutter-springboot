class Employee {
  final int? id;
  final int? employeeCode;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final String? phone;
  final String? email;
  final String? address;
  final DateTime? dateOfBirth;
  final DateTime? hireDate;
  final double? salary;
  final int? departmentCode;
  final String? departmentName;
  final int? designationCode;
  final String? designationName;
  final String? status;

  Employee({
    this.id,
    this.employeeCode,
    this.firstName,
    this.lastName,
    this.gender,
    this.phone,
    this.email,
    this.address,
    this.dateOfBirth,
    this.hireDate,
    this.salary,
    this.departmentCode,
    this.departmentName,
    this.designationCode,
    this.designationName,
    this.status,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      employeeCode: json['employeeCode'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      gender: json['gender'],
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
      dateOfBirth: json['dateOfBirth'] != null ? DateTime.parse(json['dateOfBirth']) : null,
      hireDate: json['hireDate'] != null ? DateTime.parse(json['hireDate']) : null,
      salary: json['salary'] != null ? (json['salary'] as num).toDouble() : null,
      departmentCode: json['departmentCode'],
      departmentName: json['departmentName'],
      designationCode: json['designationCode'],
      designationName: json['designationName'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeCode': employeeCode,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'phone': phone,
      'email': email,
      'address': address,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'hireDate': hireDate?.toIso8601String(),
      'salary': salary,
      'departmentCode': departmentCode,
      'departmentName': departmentName,
      'designationCode': designationCode,
      'designationName': designationName,
      'status': status,
    };
  }
}