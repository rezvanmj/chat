/// id : 320
/// f_name : "Sina"
/// l_name : "Hejazi"
/// username : "sina"
/// email : "sinahosein1382@gmail.com"
/// mobile : "5421586851"
/// address : ""
/// postalcode : null
/// active : 1
/// campaign_status : 1
/// is_active : 1
/// gender : 1
/// birthdate : "2021-10-28T00:00:00.000Z"
/// avatar : ""
/// email_verified : 1
/// email_expire_time : "2021-10-18T11:46:47.000Z"
/// mobile_verified : 1
/// mobile_expire_time : "2021-10-18T11:46:47.000Z"
/// passwordResetExp : null
/// driver_license_photo : ""
/// driver_license_NO : null
/// driver_license_expire_date : ""
/// driver_license_issued_date : ""
/// fax_NO : null
/// signiture_URL : ""
/// unsubscribe_status : "1"
/// aparteman_no : null
/// createdAt : "2021-10-18T11:46:47.000Z"
/// updatedAt : "2021-11-29T06:46:41.000Z"
/// deletedAt : ""
/// frk_dealer_ship_id : 1
/// frk_city : 100
/// frk_role : 3

class UserModel {
  int? id;
  String? fName;
  String? lName;
  String? username;
  String? email;
  String? mobile;
  String? address;
  dynamic? postalcode;
  int? active;
  int? campaignStatus;
  int? isActive;
  int? gender;
  String? birthdate;
  String? avatar;
  int? emailVerified;
  String? emailExpireTime;
  int? mobileVerified;
  String? mobileExpireTime;
  dynamic? passwordResetExp;
  String? driverLicensePhoto;
  dynamic? driverLicenseNO;
  String? driverLicenseExpireDate;
  String? driverLicenseIssuedDate;
  dynamic? faxNO;
  String? signitureURL;
  String? unsubscribeStatus;
  dynamic? apartemanNo;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? frkDealerShipId;
  int? frkCity;
  int? frkRole;

  UserModel(
      {this.id,
      this.fName,
      this.lName,
      this.username,
      this.email,
      this.mobile,
      this.address,
      this.postalcode,
      this.active,
      this.campaignStatus,
      this.isActive,
      this.gender,
      this.birthdate,
      this.avatar,
      this.emailVerified,
      this.emailExpireTime,
      this.mobileVerified,
      this.mobileExpireTime,
      this.passwordResetExp,
      this.driverLicensePhoto,
      this.driverLicenseNO,
      this.driverLicenseExpireDate,
      this.driverLicenseIssuedDate,
      this.faxNO,
      this.signitureURL,
      this.unsubscribeStatus,
      this.apartemanNo,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.frkDealerShipId,
      this.frkCity,
      this.frkRole});

  UserModel.fromJson(dynamic json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    username = json['username'];
    email = json['email'];
    mobile = json['mobile'];
    address = json['address'];
    postalcode = json['postalcode'];
    active = json['active'];
    campaignStatus = json['campaign_status'];
    isActive = json['is_active'];
    gender = json['gender'];
    birthdate = json['birthdate'];
    avatar = json['avatar'];
    emailVerified = json['email_verified'];
    emailExpireTime = json['email_expire_time'];
    mobileVerified = json['mobile_verified'];
    mobileExpireTime = json['mobile_expire_time'];
    passwordResetExp = json['passwordResetExp'];
    driverLicensePhoto = json['driver_license_photo'];
    driverLicenseNO = json['driver_license_NO'];
    driverLicenseExpireDate = json['driver_license_expire_date'];
    driverLicenseIssuedDate = json['driver_license_issued_date'];
    faxNO = json['fax_NO'];
    signitureURL = json['signiture_URL'];
    unsubscribeStatus = json['unsubscribe_status'];
    apartemanNo = json['aparteman_no'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    frkDealerShipId = json['frk_dealer_ship_id'];
    frkCity = json['frk_city'];
    frkRole = json['frk_role'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['f_name'] = fName;
    map['l_name'] = lName;
    map['username'] = username;
    map['email'] = email;
    map['mobile'] = mobile;
    map['address'] = address;
    map['postalcode'] = postalcode;
    map['active'] = active;
    map['campaign_status'] = campaignStatus;
    map['is_active'] = isActive;
    map['gender'] = gender;
    map['birthdate'] = birthdate;
    map['avatar'] = avatar;
    map['email_verified'] = emailVerified;
    map['email_expire_time'] = emailExpireTime;
    map['mobile_verified'] = mobileVerified;
    map['mobile_expire_time'] = mobileExpireTime;
    map['passwordResetExp'] = passwordResetExp;
    map['driver_license_photo'] = driverLicensePhoto;
    map['driver_license_NO'] = driverLicenseNO;
    map['driver_license_expire_date'] = driverLicenseExpireDate;
    map['driver_license_issued_date'] = driverLicenseIssuedDate;
    map['fax_NO'] = faxNO;
    map['signiture_URL'] = signitureURL;
    map['unsubscribe_status'] = unsubscribeStatus;
    map['aparteman_no'] = apartemanNo;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['deletedAt'] = deletedAt;
    map['frk_dealer_ship_id'] = frkDealerShipId;
    map['frk_city'] = frkCity;
    map['frk_role'] = frkRole;
    return map;
  }
}
