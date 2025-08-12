import 'dart:ffi';

import 'package:sizer/sizer.dart';

class MyRideModel {
  String? id;
  String? userId;
  String? uneaqueId;
  String? purpose;
  String? pickupArea;
  String? pickupDate;
  String? dropArea;
  String? pickupTime;
  String? area;
  String? landmark;
  String? pickupAddress;
  String? dropAddress;
  String? taxiType;
  String? departureTime;
  String? departureDate;
  String? returnDate;
  String? flightNumber;
  String? package;
  String? promoCode;
  String? promoDiscount;
  String? distance;
  String? amount;
  String? paidAmount;
  String? address;
  String? transfer;
  String? itemStatus;
  String? transaction;
  String? paymentMedia;
  String? km;
  String? timetype;
  String? assignedFor;
  String? isPaidAdvance;
  String? status;
  String? pointUsed;
  String? latitude;
  String? longitude;
  String? dateAdded;
  String? dropLatitude;
  String? dropLongitude;
  String? bookingType;
  String? acceptReject;
  String? driverStatus;
  String? createdDate;
  String? extra_time_charge, extra_km_charge;
  String? username;
  String? reason;
  String? surgeAmount;
  String? gstAmount;
  String? bookingId;
  String? mobile;
  String? email;
  String? gender;
  String? dob;
  String? anniversaryDate;
  String? password;
  String? tax_amount;
  String? pickupadd;
  String? activeId;
  String? userStatus;
  String? resetId;
  String? walletAmount;
  String? deviceId;
  String? type;
  String? otp;
  String? userGcmCode;
  String? otpStatus;
  String? created;
  String? modified;
  String? userImage;
  String? userImage1;
  String? referralCode;
  String? friendsCode;
  String? longnitute;
  String? name;
  String? userName;
  String? phone;
  String? licenseNo;
  String? carTypeId;
  String? carType;
  String? carNo;
  String? modelNo;
  String? rating;
  String? prefferedLocation;
  String? permitNo;
  String? insuranceNo;
  String? isVerified;
  String? isActive;
  String? isBlock;
  String? drivingLicenceNo;
  String? panCard;
  String? aadharCard;
  String? vehicalImege;
  String? carModel;
  String? bankName;
  String? accountNumber;
  String? bankCode;
  String? drivingLicencePhoto;
  String? onlineOfline;
  String? panCardStatus1;
  String? vehicalImegeStatus;
  String? cancelChargeNew;
  String? aadharCardStatus;
  String? userImageStatus;
  String? panCardStatus;
  String? createdAt;
  String? profileStatus;
  String? dateOfBirth;
  String? incentiveStatus;
  String? incentiveDate;
  String? homeAddress;
  String? profileStatusRead;
  String? baseFare;
  String? ratePerKm;
  String? timeAmount;
  String? admin_commision;
  String? totalTime;
  String? bookingTime;
  String? hours;
  String? start_time, end_time;
  String? sharing_type;
  String? price;
  String? subTotal;
  String? extraKmPrice;
  String? extraKm;
  String? finalTotal;
  String? vehicleCategory;
  String? payment_status, add_on_charge, add_on_time, add_on_distance;
  String? isParking;
  String? tollTax;
  String? parkingCharge;
  String? tollTaxCharge;
  String? railwayAirportEntryCharge;
  String? fuelType, seatingCapacity, insuranceExpiry, pollutionExpiry, vehicleNo, luggageCarrier, orderType;
  String? nightCharge;
  String? stateTax;
  String? isNightCharge;
  String? isStateTax;
  String? service_charge;
  bool? show;
  MyRideModel(
      {this.id,
      this.hours,
      this.extra_km_charge,
      this.extra_time_charge,
      this.payment_status,
      this.add_on_charge,
      this.add_on_time,
      this.add_on_distance,
      this.start_time,
      this.end_time,
      this.userId,
      this.uneaqueId,
      this.cancelChargeNew,
      this.totalTime,
      this.tax_amount,
      this.purpose,
      this.pickupArea,
      this.pickupDate,
      this.dropArea,
      this.pickupTime,
      this.area,
      this.landmark,
      this.pickupAddress,
      this.dropAddress,
      this.taxiType,
      this.departureTime,
      this.departureDate,
      this.returnDate,
      this.flightNumber,
      this.package,
      this.promoCode,
      this.promoDiscount,
      this.distance,
      this.amount,
      this.paidAmount,
      this.address,
      this.transfer,
      this.itemStatus,
      this.transaction,
      this.paymentMedia,
      this.km,
      this.timetype,
      this.assignedFor,
      this.isPaidAdvance,
      this.status,
      this.latitude,
      this.longitude,
      this.dateAdded,
      this.dropLatitude,
      this.dropLongitude,
      this.bookingType,
      this.acceptReject,
      this.driverStatus,
      this.createdDate,
      this.username,
      this.reason,
      this.pointUsed,
      this.surgeAmount,
      this.gstAmount,
      this.bookingId,
      this.mobile,
      this.email,
      this.gender,
      this.dob,
      this.anniversaryDate,
      this.password,
      this.pickupadd,
      this.activeId,
      this.userStatus,
      this.resetId,
      this.walletAmount,
      this.deviceId,
      this.type,
      this.otp,
      this.userGcmCode,
      this.otpStatus,
      this.created,
      this.modified,
      this.userImage,
      this.referralCode,
      this.friendsCode,
      this.longnitute,
      this.service_charge,
      this.name,
      this.userName,
      this.phone,
      this.licenseNo,
      this.carTypeId,
      this.carType,
      this.carNo,
      this.modelNo,
      this.rating,
      this.prefferedLocation,
      this.permitNo,
      this.insuranceNo,
      this.isVerified,
      this.isActive,
      this.isBlock,
      this.drivingLicenceNo,
      this.panCard,
      this.aadharCard,
      this.vehicalImege,
      this.carModel,
      this.bankName,
      this.accountNumber,
      this.bankCode,
      this.drivingLicencePhoto,
      this.onlineOfline,
      this.panCardStatus1,
      this.vehicalImegeStatus,
      this.aadharCardStatus,
      this.userImageStatus,
      this.panCardStatus,
      this.createdAt,
      this.profileStatus,
      this.dateOfBirth,
      this.incentiveStatus,
      this.incentiveDate,
      this.homeAddress,
      this.bookingTime,
      this.userImage1,
      this.profileStatusRead,
      this.baseFare,
      this.ratePerKm,
      this.timeAmount,
      this.show,
      this.sharing_type,
      this.price,
      this.subTotal,
      this.extraKmPrice,
      this.extraKm,
      this.finalTotal,
      this.vehicleCategory,
      this.admin_commision,
      this.fuelType,
      this.vehicleNo,
      this.luggageCarrier,
      this.insuranceExpiry,
      this.pollutionExpiry,
      this.seatingCapacity,
      this.orderType,
        this.isParking,
        this.tollTax,
        this.parkingCharge,
        this.tollTaxCharge,
        this.railwayAirportEntryCharge,
        this.nightCharge,
        this.stateTax,
        this.isNightCharge,
        this.isStateTax,
      });

  MyRideModel.fromJson(Map<String, dynamic> json) {
    print(json['created_date']);
    id = json['id'];
    userId = json['user_id'];
    payment_status = json['payment_status'];
    add_on_charge = json['add_on_charge'];
    add_on_distance = json['add_on_distance'];
    add_on_time = json['add_on_time'];
    extra_time_charge = json['extra_time_charge'];
    extra_km_charge = json['extra_km_charge'];
    totalTime = json['total_time'];
    sharing_type = json['shareing_type'];
    cancelChargeNew = json['cancel_charge'];
    tax_amount = json['tax_amount'];
    price = json['price'];
    subTotal = json['sub_total'];
    extraKmPrice = json['extra_km_price'];
    extraKm = json['extra_km'];
    finalTotal = json['final_total'];
    vehicleCategory = json['vehicle_category'];
    uneaqueId = json['uneaque_id'];
    pointUsed = json['point_used'];
    purpose = json['purpose'];
    pickupArea = json['pickup_area'];
    pickupDate = json['pickup_date'];
    dropArea = json['drop_area'];
    pickupTime = json['pickup_time'];
    area = json['area'];
    hours = json['hours'];
    service_charge = json['service_charge'];
    userImage1 = json['user_image1'];
    start_time = json['start_time'];
    end_time = json['end_time'];
    landmark = json['landmark'];
    pickupAddress = json['pickup_address'];
    dropAddress = json['drop_address'];
    taxiType = json['taxi_type'];
    departureTime = json['departure_time'];
    departureDate = json['departure_date'];
    returnDate = json['return_date'];
    flightNumber = json['flight_number'];
    package = json['package'];
    promoCode = json['promo_code'];
    promoDiscount =
        json['promo_discount'] != null && json['promo_discount'] != ""
            ? json['promo_discount']
            : "0";
    distance = json['distance'];
    amount = json['amount'];
    paidAmount = json['paid_amount'];
    address = json['address'];
    transfer = json['transfer'];
    itemStatus = json['item_status'];
    transaction = json['transaction'] != null && json['transaction'] != ""
        ? json['transaction']
        : "Wait For Payment";
    paymentMedia = json['payment_media'];
    km = json['km'];
    timetype = json['timetype'];
    assignedFor = json['assigned_for'];
    isPaidAdvance = json['is_paid_advance'];
    status = json['status'];
    latitude = json['book_latitude'] != null
        ? json['book_latitude']
        : json['latitude'];
    longitude = json['book_longitude'] != null
        ? json['book_longitude']
        : json['longitude'];
    dateAdded = json['date_added'];
    dropLatitude = json['drop_latitude'];
    dropLongitude = json['drop_longitude'];
    bookingType = json['booking_type'];
    acceptReject = json['accept_reject'];
    driverStatus = json['driver_status'];
    createdDate = json['created_date'];
    username = json['username'];
    reason = json['reason'];
    surgeAmount = json['surge_amount'];
    gstAmount = json['gst_amount'];
    bookingId = json['booking_id'];
    mobile = json['mobile'];
    email = json['email'];
    gender = json['gender'];
    dob = json['dob'];
    anniversaryDate = json['anniversary_date'];
    password = json['password'];
    pickupadd = json['pickupadd'];
    activeId = json['active_id'];
    userStatus = json['user_status'];
    resetId = json['reset_id'];
    walletAmount = json['wallet_amount'];
    deviceId = json['device_id'];
    type = json['type'];
    otp = json['otp'];
    userGcmCode = json['user_gcm_code'];
    otpStatus = json['otp_status'];
    created = json['created'];
    modified = json['modified'];
    userImage = json['user_image'];
    referralCode = json['referral_code'];
    friendsCode = json['friends_code'];
    longnitute = json['longnitute'];
    name = json['name'];
    userName = json['user_name'];
    phone = json['phone'];
    licenseNo = json['license_no'];
    carTypeId = json['car_type_id'];
    carType = json['car_type'];
    carNo = json['car_no'];
    modelNo = json['model_no'];
    rating = json['rating'];
    prefferedLocation = json['preffered_location'];
    permitNo = json['permit_no'];
    insuranceNo = json['insurance_no'];
    isVerified = json['is_verified'];
    isActive = json['is_active'];
    isBlock = json['is_block'];
    drivingLicenceNo = json['driving_licence_no'];
    panCard = json['pan_card'];
    aadharCard = json['aadhar_card'];
    vehicalImege = json['vehical_imege'];
    carModel = json['car_model'];
    bankName = json['bank_name'];
    accountNumber = json['account_number'];
    bankCode = json['bank_code'];
    drivingLicencePhoto = json['driving_licence_photo'];
    onlineOfline = json['online_ofline'];
    panCardStatus1 = json['pan_card_status1'];
    vehicalImegeStatus = json['vehical_imege_status'];
    aadharCardStatus = json['aadhar_card_status'];
    userImageStatus = json['user_image_status'];
    panCardStatus = json['pan_card_status'];
    createdAt = json['created_at'];
    profileStatus = json['profile_status'];
    dateOfBirth = json['date_of_birth'];
    incentiveStatus = json['incentive_status'];
    incentiveDate = json['incentive_date'];
    homeAddress = json['home_address'];
    profileStatusRead = json['profile_status_read'];
    baseFare = json['base_fare'];
    timeAmount = json['time_amount'];
    admin_commision = json['admin_commision'];
    ratePerKm = json['rate_per_km'];
    bookingTime = json['booking_time'];
    fuelType = json['fuel_type'];
    seatingCapacity = json['seating_capacity'];
    insuranceExpiry = json['insurance_expiry'];
    pollutionExpiry = json['pollution_expiry'];
    vehicleNo = json['vehicle_no'];
    luggageCarrier = json['luggage_carrier'];
    orderType = json['order_type'];
    isParking = json['is_parking'];
    tollTax = json['is_toll_tax'];
    parkingCharge = json['parking_charge'];
    tollTaxCharge = json['toll_tax_charge'];
    railwayAirportEntryCharge = json['railway_airport_entry_charge'];
    nightCharge = json['night_charge'];
    stateTax = json['state_tax_charge'];
    isStateTax = json['is_state_tax'];
    isNightCharge = json['is_night_charge'];
    show = true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['uneaque_id'] = this.uneaqueId;
    data['purpose'] = this.purpose;
    data['pickup_area'] = this.pickupArea;
    data['pickup_date'] = this.pickupDate;
    data['drop_area'] = this.dropArea;
    data['pickup_time'] = this.pickupTime;
    data['area'] = this.area;
    data['landmark'] = this.landmark;
    data['service_charge'] = this.service_charge;
    data['tax_amount'] = this.tax_amount;
    data['pickup_address'] = this.pickupAddress;
    data['cancel_charge'] = this.cancelChargeNew;
    data['drop_address'] = this.dropAddress;
    data['taxi_type'] = this.taxiType;
    data['departure_time'] = this.departureTime;
    data['departure_date'] = this.departureDate;
    data['return_date'] = this.returnDate;
    data['flight_number'] = this.flightNumber;
    data['package'] = this.package;
    data['point_used'] = this.pointUsed;
    data['promo_code'] = this.promoCode;
    data['promo_discount'] = this.promoDiscount;
    data['distance'] = this.distance;
    data['amount'] = this.amount;
    data['paid_amount'] = this.paidAmount;
    data['address'] = this.address;
    data['transfer'] = this.transfer;
    data['item_status'] = this.itemStatus;
    data['transaction'] = this.transaction;
    data['payment_media'] = this.paymentMedia;
    data['km'] = this.km;
    data['timetype'] = this.timetype;
    data['assigned_for'] = this.assignedFor;
    data['is_paid_advance'] = this.isPaidAdvance;
    data['status'] = this.status;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['date_added'] = this.dateAdded;
    data['drop_latitude'] = this.dropLatitude;
    data['drop_longitude'] = this.dropLongitude;
    data['booking_type'] = this.bookingType;
    data['accept_reject'] = this.acceptReject;
    data['driver_status'] = this.driverStatus;
    data['created_date'] = this.createdDate;
    data['username'] = this.username;
    data['reason'] = this.reason;
    data['surge_amount'] = this.surgeAmount;
    data['gst_amount'] = this.gstAmount;
    data['booking_id'] = this.bookingId;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['anniversary_date'] = this.anniversaryDate;
    data['password'] = this.password;
    data['pickupadd'] = this.pickupadd;
    data['active_id'] = this.activeId;
    data['user_status'] = this.userStatus;
    data['reset_id'] = this.resetId;
    data['wallet_amount'] = this.walletAmount;
    data['device_id'] = this.deviceId;
    data['type'] = this.type;
    data['otp'] = this.otp;
    data['user_gcm_code'] = this.userGcmCode;
    data['otp_status'] = this.otpStatus;
    data['created'] = this.created;
    data['modified'] = this.modified;
    data['user_image'] = this.userImage;
    data['referral_code'] = this.referralCode;
    data['friends_code'] = this.friendsCode;
    data['longnitute'] = this.longnitute;
    data['name'] = this.name;
    data['user_name'] = this.userName;
    data['phone'] = this.phone;
    data['license_no'] = this.licenseNo;
    data['car_type_id'] = this.carTypeId;
    data['car_type'] = this.carType;
    data['car_no'] = this.carNo;
    data['model_no'] = this.modelNo;
    data['rating'] = this.rating;
    data['preffered_location'] = this.prefferedLocation;
    data['permit_no'] = this.permitNo;
    data['insurance_no'] = this.insuranceNo;
    data['is_verified'] = this.isVerified;
    data['is_active'] = this.isActive;
    data['is_block'] = this.isBlock;
    data['driving_licence_no'] = this.drivingLicenceNo;
    data['pan_card'] = this.panCard;
    data['aadhar_card'] = this.aadharCard;
    data['vehical_imege'] = this.vehicalImege;
    data['car_model'] = this.carModel;
    data['bank_name'] = this.bankName;
    data['account_number'] = this.accountNumber;
    data['bank_code'] = this.bankCode;
    data['driving_licence_photo'] = this.drivingLicencePhoto;
    data['online_ofline'] = this.onlineOfline;
    data['pan_card_status1'] = this.panCardStatus1;
    data['vehical_imege_status'] = this.vehicalImegeStatus;
    data['aadhar_card_status'] = this.aadharCardStatus;
    data['user_image_status'] = this.userImageStatus;
    data['pan_card_status'] = this.panCardStatus;
    data['created_at'] = this.createdAt;
    data['profile_status'] = this.profileStatus;
    data['date_of_birth'] = this.dateOfBirth;
    data['incentive_status'] = this.incentiveStatus;
    data['incentive_date'] = this.incentiveDate;
    data['home_address'] = this.homeAddress;
    data['profile_status_read'] = this.profileStatusRead;
    data['booking_time'] = this.bookingTime;
    data['price'] = this.price;
    data['sub_total'] = this.subTotal;
    data['extra_km_price'] = this.extraKmPrice;
    data['extra_km'] = this.extraKm;
    data['final_total'] = this.finalTotal;
    data['vehicle_category'] = this.vehicleCategory;
    data['order_type'] = this.orderType;
    data['is_parking'] = this.isParking;
    data['is_toll_tax'] = this.tollTax;
    data['parking_charge'] = this.parkingCharge;
    data['toll_tax_charge'] = this.tollTaxCharge;
    data['railway_airport_entry_charge'] = this.railwayAirportEntryCharge;
    data['night_charge'] = this.nightCharge;
    data['state_tax_charge'] = this.stateTax;
    data['is_night_charge'] = this.isNightCharge;
    data['is_state_tax'] = this.isStateTax;
    return data;
  }
}

class SingleRideModel {
  bool? status;
  String? message;
  List<RideData>? data;
  List<Odhometer>? odhometer;

  SingleRideModel({this.status, this.message, this.data, this.odhometer});

  SingleRideModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RideData>[];
      json['data'].forEach((v) {
        data!.add(new RideData.fromJson(v));
      });
    }
    if (json['odhometer'] != null) {
      odhometer = <Odhometer>[];
      json['odhometer'].forEach((v) {
        odhometer!.add(new Odhometer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.odhometer != null) {
      data['odhometer'] = this.odhometer!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RideData {
  String? dtime;
  String? id;
  String? userId;
  String? uneaqueId;
  String? vendorId;
  String? vehicleId;
  String? orderType;
  Null? purpose;
  Null? pickupArea;
  String? pickupDate;
  Null? dropArea;
  String? pickupTime;
  Null? area;
  Null? landmark;
  String? pickupAddress;
  String? dropAddress;
  String? taxiType;
  Null? departureTime;
  Null? departureDate;
  Null? returnDate;
  Null? flightNumber;
  Null? package;
  String? promoCode;
  Null? distance;
  String? amount;
  String? paidAmount;
  Null? address;
  Null? transfer;
  Null? itemStatus;
  String? transaction;
  Null? paymentMedia;
  String? km;
  Null? timetype;
  String? assignedFor;
  String? isPaidAdvance;
  String? status;
  String? latitude;
  String? longitude;
  String? dateAdded;
  String? dropLatitude;
  String? dropLongitude;
  String? bookingType;
  String? acceptReject;
  String? createdDate;
  String? username;
  Null? reason;
  Null? surgeAmount;
  String? gstAmount;
  String? baseFare;
  String? timeAmount;
  String? ratePerKm;
  String? adminCommision;
  String? totalTime;
  String? cancelCharge;
  Null? carCategories;
  String? startTime;
  String? endTime;
  String? taxiId;
  Null? hours;
  String? bookingTime;
  Null? shareingType;
  Null? sharingUserId;
  String? promoDiscount;
  String? paymentStatus;
  String? bookingOtp;
  String? deliveryType;
  Null? otpStatus;
  Null? extraTimeCharge;
  Null? extraKmCharge;
  Null? pickupCity;
  Null? dropCity;
  Null? addOnCharge;
  Null? addOnTime;
  Null? addOnDistance;
  Null? estimateAmountWallet;
  Null? surgePercentage;
  Null? initialAmount;
  Null? taxPercentage;
  Null? adminPercentage;
  String? cancelRide;
  String? driverStatus;
  String? createdAt;
  String? updatedAt;
  String? driverImage;
  String? bookLatitude;
  String? bookLongitude;
  String? userImage1;
  String? bookingId;
  String? mobile;
  String? email;
  String? gender;
  String? dob;
  Null? anniversaryDate;
  Null? password;
  Null? pickupadd;
  Null? activeId;
  Null? userStatus;
  Null? resetId;
  String? walletAmount;
  String? deviceId;
  Null? type;
  Null? rcNumber;
  String? otp;
  String? userGcmCode;
  String? created;
  String? modified;
  String? userImage;
  String? referralCode;
  String? friendsCode;
  Null? longnitute;
  String? newPassword;
  String? firstOrder;
  String? startDate;
  String? endDate;
  String? planId;
  Null? name;
  String? userName;
  String? phone;
  Null? licenseNo;
  Null? carTypeId;
  String? carType;
  String? carNo;
  Null? bankChaque;
  Null? driverBalance;
  Null? rating;
  Null? prefferedLocation;
  Null? insuranceNo;
  String? isVerified;
  String? isActive;
  String? isBlock;
  String? drivingLicenceNo;
  String? panCard;
  Null? aadharCard;
  Null? vehicalImege;
  String? carModel;
  String? bankName;
  String? accountNumber;
  String? ifscCode;
  String? drivingLicencePhoto;
  String? onlineOfline;
  Null? panCardStatus1;
  Null? vehicalImegeStatus;
  Null? aadharCardStatus;
  Null? userImageStatus;
  Null? panCardStatus;
  String? profileStatus;
  Null? dateOfBirth;
  Null? incentiveStatus;
  String? incentiveDate;
  String? licenseExpiry;
  String? homeAddress;
  Null? profileStatusRead;
  String? profileReadStatus;
  String? bounusEndDate;
  String? bounusAmount;
  String? joiningIncBounus;
  String? insurance;
  String? newDriver;
  String? reject;
  String? licenseIssue;

  RideData(
      {this.dtime,
        this.id,
        this.userId,
        this.uneaqueId,
        this.vendorId,
        this.vehicleId,
        this.orderType,
        this.purpose,
        this.pickupArea,
        this.pickupDate,
        this.dropArea,
        this.pickupTime,
        this.area,
        this.landmark,
        this.pickupAddress,
        this.dropAddress,
        this.taxiType,
        this.departureTime,
        this.departureDate,
        this.returnDate,
        this.flightNumber,
        this.package,
        this.promoCode,
        this.distance,
        this.amount,
        this.paidAmount,
        this.address,
        this.transfer,
        this.itemStatus,
        this.transaction,
        this.paymentMedia,
        this.km,
        this.timetype,
        this.assignedFor,
        this.isPaidAdvance,
        this.status,
        this.latitude,
        this.longitude,
        this.dateAdded,
        this.dropLatitude,
        this.dropLongitude,
        this.bookingType,
        this.acceptReject,
        this.createdDate,
        this.username,
        this.reason,
        this.surgeAmount,
        this.gstAmount,
        this.baseFare,
        this.timeAmount,
        this.ratePerKm,
        this.adminCommision,
        this.totalTime,
        this.cancelCharge,
        this.carCategories,
        this.startTime,
        this.endTime,
        this.taxiId,
        this.hours,
        this.bookingTime,
        this.shareingType,
        this.sharingUserId,
        this.promoDiscount,
        this.paymentStatus,
        this.bookingOtp,
        this.deliveryType,
        this.otpStatus,
        this.extraTimeCharge,
        this.extraKmCharge,
        this.pickupCity,
        this.dropCity,
        this.addOnCharge,
        this.addOnTime,
        this.addOnDistance,
        this.estimateAmountWallet,
        this.surgePercentage,
        this.initialAmount,
        this.taxPercentage,
        this.adminPercentage,
        this.cancelRide,
        this.driverStatus,
        this.createdAt,
        this.updatedAt,
        this.driverImage,
        this.bookLatitude,
        this.bookLongitude,
        this.userImage1,
        this.bookingId,
        this.mobile,
        this.email,
        this.gender,
        this.dob,
        this.anniversaryDate,
        this.password,
        this.pickupadd,
        this.activeId,
        this.userStatus,
        this.resetId,
        this.walletAmount,
        this.deviceId,
        this.type,
        this.rcNumber,
        this.otp,
        this.userGcmCode,
        this.created,
        this.modified,
        this.userImage,
        this.referralCode,
        this.friendsCode,
        this.longnitute,
        this.newPassword,
        this.firstOrder,
        this.startDate,
        this.endDate,
        this.planId,
        this.name,
        this.userName,
        this.phone,
        this.licenseNo,
        this.carTypeId,
        this.carType,
        this.carNo,
        this.bankChaque,
        this.driverBalance,
        this.rating,
        this.prefferedLocation,
        this.insuranceNo,
        this.isVerified,
        this.isActive,
        this.isBlock,
        this.drivingLicenceNo,
        this.panCard,
        this.aadharCard,
        this.vehicalImege,
        this.carModel,
        this.bankName,
        this.accountNumber,
        this.ifscCode,
        this.drivingLicencePhoto,
        this.onlineOfline,
        this.panCardStatus1,
        this.vehicalImegeStatus,
        this.aadharCardStatus,
        this.userImageStatus,
        this.panCardStatus,
        this.profileStatus,
        this.dateOfBirth,
        this.incentiveStatus,
        this.incentiveDate,
        this.licenseExpiry,
        this.homeAddress,
        this.profileStatusRead,
        this.profileReadStatus,
        this.bounusEndDate,
        this.bounusAmount,
        this.joiningIncBounus,
        this.insurance,
        this.newDriver,
        this.reject,
        this.licenseIssue});

  RideData.fromJson(Map<String, dynamic> json) {
    dtime = json['dtime'];
    id = json['id'];
    userId = json['user_id'];
    uneaqueId = json['uneaque_id'];
    vendorId = json['vendor_id'];
    vehicleId = json['vehicle_id'];
    orderType = json['order_type'];
    purpose = json['purpose'];
    pickupArea = json['pickup_area'];
    pickupDate = json['pickup_date'];
    dropArea = json['drop_area'];
    pickupTime = json['pickup_time'];
    area = json['area'];
    landmark = json['landmark'];
    pickupAddress = json['pickup_address'];
    dropAddress = json['drop_address'];
    taxiType = json['taxi_type'];
    departureTime = json['departure_time'];
    departureDate = json['departure_date'];
    returnDate = json['return_date'];
    flightNumber = json['flight_number'];
    package = json['package'];
    promoCode = json['promo_code'];
    distance = json['distance'];
    amount = json['amount'];
    paidAmount = json['paid_amount'];
    address = json['address'];
    transfer = json['transfer'];
    itemStatus = json['item_status'];
    transaction = json['transaction'];
    paymentMedia = json['payment_media'];
    km = json['km'];
    timetype = json['timetype'];
    assignedFor = json['assigned_for'];
    isPaidAdvance = json['is_paid_advance'];
    status = json['status'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    dateAdded = json['date_added'];
    dropLatitude = json['drop_latitude'];
    dropLongitude = json['drop_longitude'];
    bookingType = json['booking_type'];
    acceptReject = json['accept_reject'];
    createdDate = json['created_date'];
    username = json['username'];
    reason = json['reason'];
    surgeAmount = json['surge_amount'];
    gstAmount = json['gst_amount'];
    baseFare = json['base_fare'];
    timeAmount = json['time_amount'];
    ratePerKm = json['rate_per_km'];
    adminCommision = json['admin_commision'];
    totalTime = json['total_time'];
    cancelCharge = json['cancel_charge'];
    carCategories = json['car_categories'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    taxiId = json['taxi_id'];
    hours = json['hours'];
    bookingTime = json['booking_time'];
    shareingType = json['shareing_type'];
    sharingUserId = json['sharing_user_id'];
    promoDiscount = json['promo_discount'];
    paymentStatus = json['payment_status'];
    bookingOtp = json['booking_otp'];
    deliveryType = json['delivery_type'];
    otpStatus = json['otp_status'];
    extraTimeCharge = json['extra_time_charge'];
    extraKmCharge = json['extra_km_charge'];
    pickupCity = json['pickup_city'];
    dropCity = json['drop_city'];
    addOnCharge = json['add_on_charge'];
    addOnTime = json['add_on_time'];
    addOnDistance = json['add_on_distance'];
    estimateAmountWallet = json['estimate_amount_wallet'];
    surgePercentage = json['surge_percentage'];
    initialAmount = json['initial_amount'];
    taxPercentage = json['tax_percentage'];
    adminPercentage = json['admin_percentage'];
    cancelRide = json['cancel_ride'];
    driverStatus = json['driver_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    driverImage = json['driver_image'];
    bookLatitude = json['book_latitude'];
    bookLongitude = json['book_longitude'];
    userImage1 = json['user_image1'];
    bookingId = json['booking_id'];
    mobile = json['mobile'];
    email = json['email'];
    gender = json['gender'];
    dob = json['dob'];
    anniversaryDate = json['anniversary_date'];
    password = json['password'];
    pickupadd = json['pickupadd'];
    activeId = json['active_id'];
    userStatus = json['user_status'];
    resetId = json['reset_id'];
    walletAmount = json['wallet_amount'];
    deviceId = json['device_id'];
    type = json['type'];
    rcNumber = json['rc_number'];
    otp = json['otp'];
    userGcmCode = json['user_gcm_code'];
    created = json['created'];
    modified = json['modified'];
    userImage = json['user_image'];
    referralCode = json['referral_code'];
    friendsCode = json['friends_code'];
    longnitute = json['longnitute'];
    newPassword = json['new_password'];
    firstOrder = json['first_order'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    planId = json['plan_id'];
    name = json['name'];
    userName = json['user_name'];
    phone = json['phone'];
    licenseNo = json['license_no'];
    carTypeId = json['car_type_id'];
    carType = json['car_type'];
    carNo = json['car_no'];
    bankChaque = json['bank_chaque'];
    driverBalance = json['driver_balance'];
    rating = json['rating'];
    prefferedLocation = json['preffered_location'];
    insuranceNo = json['insurance_no'];
    isVerified = json['is_verified'];
    isActive = json['is_active'];
    isBlock = json['is_block'];
    drivingLicenceNo = json['driving_licence_no'];
    panCard = json['pan_card'];
    aadharCard = json['aadhar_card'];
    vehicalImege = json['vehical_imege'];
    carModel = json['car_model'];
    bankName = json['bank_name'];
    accountNumber = json['account_number'];
    ifscCode = json['ifsc_code'];
    drivingLicencePhoto = json['driving_licence_photo'];
    onlineOfline = json['online_ofline'];
    panCardStatus1 = json['pan_card_status1'];
    vehicalImegeStatus = json['vehical_imege_status'];
    aadharCardStatus = json['aadhar_card_status'];
    userImageStatus = json['user_image_status'];
    panCardStatus = json['pan_card_status'];
    profileStatus = json['profile_status'];
    dateOfBirth = json['date_of_birth'];
    incentiveStatus = json['incentive_status'];
    incentiveDate = json['incentive_date'];
    licenseExpiry = json['license_expiry'];
    homeAddress = json['home_address'];
    profileStatusRead = json['profile_status_read'];
    profileReadStatus = json['profile_read_status'];
    bounusEndDate = json['bounus_end_date'];
    bounusAmount = json['bounus_amount'];
    joiningIncBounus = json['joining_inc_bounus'];
    insurance = json['insurance'];
    newDriver = json['new_driver'];
    reject = json['reject'];
    licenseIssue = json['license_issue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dtime'] = this.dtime;
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['uneaque_id'] = this.uneaqueId;
    data['vendor_id'] = this.vendorId;
    data['vehicle_id'] = this.vehicleId;
    data['order_type'] = this.orderType;
    data['purpose'] = this.purpose;
    data['pickup_area'] = this.pickupArea;
    data['pickup_date'] = this.pickupDate;
    data['drop_area'] = this.dropArea;
    data['pickup_time'] = this.pickupTime;
    data['area'] = this.area;
    data['landmark'] = this.landmark;
    data['pickup_address'] = this.pickupAddress;
    data['drop_address'] = this.dropAddress;
    data['taxi_type'] = this.taxiType;
    data['departure_time'] = this.departureTime;
    data['departure_date'] = this.departureDate;
    data['return_date'] = this.returnDate;
    data['flight_number'] = this.flightNumber;
    data['package'] = this.package;
    data['promo_code'] = this.promoCode;
    data['distance'] = this.distance;
    data['amount'] = this.amount;
    data['paid_amount'] = this.paidAmount;
    data['address'] = this.address;
    data['transfer'] = this.transfer;
    data['item_status'] = this.itemStatus;
    data['transaction'] = this.transaction;
    data['payment_media'] = this.paymentMedia;
    data['km'] = this.km;
    data['timetype'] = this.timetype;
    data['assigned_for'] = this.assignedFor;
    data['is_paid_advance'] = this.isPaidAdvance;
    data['status'] = this.status;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['date_added'] = this.dateAdded;
    data['drop_latitude'] = this.dropLatitude;
    data['drop_longitude'] = this.dropLongitude;
    data['booking_type'] = this.bookingType;
    data['accept_reject'] = this.acceptReject;
    data['created_date'] = this.createdDate;
    data['username'] = this.username;
    data['reason'] = this.reason;
    data['surge_amount'] = this.surgeAmount;
    data['gst_amount'] = this.gstAmount;
    data['base_fare'] = this.baseFare;
    data['time_amount'] = this.timeAmount;
    data['rate_per_km'] = this.ratePerKm;
    data['admin_commision'] = this.adminCommision;
    data['total_time'] = this.totalTime;
    data['cancel_charge'] = this.cancelCharge;
    data['car_categories'] = this.carCategories;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['taxi_id'] = this.taxiId;
    data['hours'] = this.hours;
    data['booking_time'] = this.bookingTime;
    data['shareing_type'] = this.shareingType;
    data['sharing_user_id'] = this.sharingUserId;
    data['promo_discount'] = this.promoDiscount;
    data['payment_status'] = this.paymentStatus;
    data['booking_otp'] = this.bookingOtp;
    data['delivery_type'] = this.deliveryType;
    data['otp_status'] = this.otpStatus;
    data['extra_time_charge'] = this.extraTimeCharge;
    data['extra_km_charge'] = this.extraKmCharge;
    data['pickup_city'] = this.pickupCity;
    data['drop_city'] = this.dropCity;
    data['add_on_charge'] = this.addOnCharge;
    data['add_on_time'] = this.addOnTime;
    data['add_on_distance'] = this.addOnDistance;
    data['estimate_amount_wallet'] = this.estimateAmountWallet;
    data['surge_percentage'] = this.surgePercentage;
    data['initial_amount'] = this.initialAmount;
    data['tax_percentage'] = this.taxPercentage;
    data['admin_percentage'] = this.adminPercentage;
    data['cancel_ride'] = this.cancelRide;
    data['driver_status'] = this.driverStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['driver_image'] = this.driverImage;
    data['book_latitude'] = this.bookLatitude;
    data['book_longitude'] = this.bookLongitude;
    data['user_image1'] = this.userImage1;
    data['booking_id'] = this.bookingId;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['anniversary_date'] = this.anniversaryDate;
    data['password'] = this.password;
    data['pickupadd'] = this.pickupadd;
    data['active_id'] = this.activeId;
    data['user_status'] = this.userStatus;
    data['reset_id'] = this.resetId;
    data['wallet_amount'] = this.walletAmount;
    data['device_id'] = this.deviceId;
    data['type'] = this.type;
    data['rc_number'] = this.rcNumber;
    data['otp'] = this.otp;
    data['user_gcm_code'] = this.userGcmCode;
    data['created'] = this.created;
    data['modified'] = this.modified;
    data['user_image'] = this.userImage;
    data['referral_code'] = this.referralCode;
    data['friends_code'] = this.friendsCode;
    data['longnitute'] = this.longnitute;
    data['new_password'] = this.newPassword;
    data['first_order'] = this.firstOrder;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['plan_id'] = this.planId;
    data['name'] = this.name;
    data['user_name'] = this.userName;
    data['phone'] = this.phone;
    data['license_no'] = this.licenseNo;
    data['car_type_id'] = this.carTypeId;
    data['car_type'] = this.carType;
    data['car_no'] = this.carNo;
    data['bank_chaque'] = this.bankChaque;
    data['driver_balance'] = this.driverBalance;
    data['rating'] = this.rating;
    data['preffered_location'] = this.prefferedLocation;
    data['insurance_no'] = this.insuranceNo;
    data['is_verified'] = this.isVerified;
    data['is_active'] = this.isActive;
    data['is_block'] = this.isBlock;
    data['driving_licence_no'] = this.drivingLicenceNo;
    data['pan_card'] = this.panCard;
    data['aadhar_card'] = this.aadharCard;
    data['vehical_imege'] = this.vehicalImege;
    data['car_model'] = this.carModel;
    data['bank_name'] = this.bankName;
    data['account_number'] = this.accountNumber;
    data['ifsc_code'] = this.ifscCode;
    data['driving_licence_photo'] = this.drivingLicencePhoto;
    data['online_ofline'] = this.onlineOfline;
    data['pan_card_status1'] = this.panCardStatus1;
    data['vehical_imege_status'] = this.vehicalImegeStatus;
    data['aadhar_card_status'] = this.aadharCardStatus;
    data['user_image_status'] = this.userImageStatus;
    data['pan_card_status'] = this.panCardStatus;
    data['profile_status'] = this.profileStatus;
    data['date_of_birth'] = this.dateOfBirth;
    data['incentive_status'] = this.incentiveStatus;
    data['incentive_date'] = this.incentiveDate;
    data['license_expiry'] = this.licenseExpiry;
    data['home_address'] = this.homeAddress;
    data['profile_status_read'] = this.profileStatusRead;
    data['profile_read_status'] = this.profileReadStatus;
    data['bounus_end_date'] = this.bounusEndDate;
    data['bounus_amount'] = this.bounusAmount;
    data['joining_inc_bounus'] = this.joiningIncBounus;
    data['insurance'] = this.insurance;
    data['new_driver'] = this.newDriver;
    data['reject'] = this.reject;
    data['license_issue'] = this.licenseIssue;
    return data;
  }
}

class Odhometer {
  String? id;
  String? bookingId;
  String? title;
  String? image;
  String? value;
  String? createdAt;
  String? updatedAt;

  Odhometer(
      {this.id,
        this.bookingId,
        this.title,
        this.image,
        this.value,
        this.createdAt,
        this.updatedAt});

  Odhometer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingId = json['booking_id'];
    title = json['title'];
    image = json['image'];
    value = json['value'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['booking_id'] = this.bookingId;
    data['title'] = this.title;
    data['image'] = this.image;
    data['value'] = this.value;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
