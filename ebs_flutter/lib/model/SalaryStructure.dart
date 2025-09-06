class SalaryStructure {
  final int? id;
  final int? salaryStructureCode;
  final int? designationCode;
  final String? designationName;
  final double? basicSalary;
  final double? houseRent;
  final double? medicalAllowance;
  final double? transportAllowance;
  final double? others;
  final double? grossSalary;

  SalaryStructure({
    this.id,
    this.salaryStructureCode,
    this.designationCode,
    this.designationName,
    this.basicSalary,
    this.houseRent,
    this.medicalAllowance,
    this.transportAllowance,
    this.others,
    this.grossSalary,
  });

  factory SalaryStructure.fromJson(Map<String, dynamic> json) {
    return SalaryStructure(
      id: json['id'],
      salaryStructureCode: json['salaryStructureCode'],
      designationCode: json['designationCode'],
      designationName: json['designationName'],
      basicSalary: json['basicSalary'] != null ? (json['basicSalary'] as num).toDouble() : null,
      houseRent: json['houseRent'] != null ? (json['houseRent'] as num).toDouble() : null,
      medicalAllowance: json['medicalAllowance'] != null ? (json['medicalAllowance'] as num).toDouble() : null,
      transportAllowance: json['transportAllowance'] != null ? (json['transportAllowance'] as num).toDouble() : null,
      others: json['others'] != null ? (json['others'] as num).toDouble() : null,
      grossSalary: json['grossSalary'] != null ? (json['grossSalary'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'salaryStructureCode': salaryStructureCode,
      'designationCode': designationCode,
      'designationName': designationName,
      'basicSalary': basicSalary,
      'houseRent': houseRent,
      'medicalAllowance': medicalAllowance,
      'transportAllowance': transportAllowance,
      'others': others,
      'grossSalary': grossSalary,
    };
  }
}