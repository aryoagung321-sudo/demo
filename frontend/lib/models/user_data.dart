class UserData {
  // Personal Information
  String? fullName;
  String? phoneNumber;
  String? email;
  String? dateOfBirth;
  String? gender;
  String? maritalStatus;
  String? province;
  String? city;
  String? district;
  String? subDistrict;
  String? streetAddress;
  
  // Emergency Contacts
  String? emergencyContact1Name;
  String? emergencyContact1Phone;
  String? emergencyContact1Relationship;
  String? emergencyContact2Name;
  String? emergencyContact2Phone;
  String? emergencyContact2Relationship;
  
  // Identity Documents
  String? ktpNumber;
  String? ktpName;
  String? ktpPhotoPath;
  String? selfiePhotoPath;
  
  // Bank Information
  String? bankName;
  String? accountNumber;
  String? accountHolderName;
  
  // Loan Information
  double? requestedAmount;
  String? loanStatus; // 'pending', 'approved', 'rejected', 'overdue'
  String? loanProduct;
  DateTime? applicationDate;
  DateTime? dueDate;
  
  // Device Information
  String? imei;
  String? deviceModel;
  String? osVersion;
  
  // Permissions
  bool? locationPermission;
  bool? cameraPermission;
  bool? contactsPermission;
  bool? phonePermission;
  bool? storagePermission;
  
  UserData({
    this.fullName,
    this.phoneNumber,
    this.email,
    this.dateOfBirth,
    this.gender,
    this.maritalStatus,
    this.province,
    this.city,
    this.district,
    this.subDistrict,
    this.streetAddress,
    this.emergencyContact1Name,
    this.emergencyContact1Phone,
    this.emergencyContact1Relationship,
    this.emergencyContact2Name,
    this.emergencyContact2Phone,
    this.emergencyContact2Relationship,
    this.ktpNumber,
    this.ktpName,
    this.ktpPhotoPath,
    this.selfiePhotoPath,
    this.bankName,
    this.accountNumber,
    this.accountHolderName,
    this.requestedAmount,
    this.loanStatus,
    this.loanProduct,
    this.applicationDate,
    this.dueDate,
    this.imei,
    this.deviceModel,
    this.osVersion,
    this.locationPermission,
    this.cameraPermission,
    this.contactsPermission,
    this.phonePermission,
    this.storagePermission,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'email': email,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'maritalStatus': maritalStatus,
      'province': province,
      'city': city,
      'district': district,
      'subDistrict': subDistrict,
      'streetAddress': streetAddress,
      'emergencyContact1Name': emergencyContact1Name,
      'emergencyContact1Phone': emergencyContact1Phone,
      'emergencyContact1Relationship': emergencyContact1Relationship,
      'emergencyContact2Name': emergencyContact2Name,
      'emergencyContact2Phone': emergencyContact2Phone,
      'emergencyContact2Relationship': emergencyContact2Relationship,
      'ktpNumber': ktpNumber,
      'ktpName': ktpName,
      'ktpPhotoPath': ktpPhotoPath,
      'selfiePhotoPath': selfiePhotoPath,
      'bankName': bankName,
      'accountNumber': accountNumber,
      'accountHolderName': accountHolderName,
      'requestedAmount': requestedAmount,
      'loanStatus': loanStatus,
      'loanProduct': loanProduct,
      'applicationDate': applicationDate?.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'imei': imei,
      'deviceModel': deviceModel,
      'osVersion': osVersion,
      'locationPermission': locationPermission,
      'cameraPermission': cameraPermission,
      'contactsPermission': contactsPermission,
      'phonePermission': phonePermission,
      'storagePermission': storagePermission,
    };
  }
  
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      dateOfBirth: json['dateOfBirth'],
      gender: json['gender'],
      maritalStatus: json['maritalStatus'],
      province: json['province'],
      city: json['city'],
      district: json['district'],
      subDistrict: json['subDistrict'],
      streetAddress: json['streetAddress'],
      emergencyContact1Name: json['emergencyContact1Name'],
      emergencyContact1Phone: json['emergencyContact1Phone'],
      emergencyContact1Relationship: json['emergencyContact1Relationship'],
      emergencyContact2Name: json['emergencyContact2Name'],
      emergencyContact2Phone: json['emergencyContact2Phone'],
      emergencyContact2Relationship: json['emergencyContact2Relationship'],
      ktpNumber: json['ktpNumber'],
      ktpName: json['ktpName'],
      ktpPhotoPath: json['ktpPhotoPath'],
      selfiePhotoPath: json['selfiePhotoPath'],
      bankName: json['bankName'],
      accountNumber: json['accountNumber'],
      accountHolderName: json['accountHolderName'],
      requestedAmount: json['requestedAmount']?.toDouble(),
      loanStatus: json['loanStatus'],
      loanProduct: json['loanProduct'],
      applicationDate: json['applicationDate'] != null ? DateTime.parse(json['applicationDate']) : null,
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      imei: json['imei'],
      deviceModel: json['deviceModel'],
      osVersion: json['osVersion'],
      locationPermission: json['locationPermission'],
      cameraPermission: json['cameraPermission'],
      contactsPermission: json['contactsPermission'],
      phonePermission: json['phonePermission'],
      storagePermission: json['storagePermission'],
    );
  }
} 