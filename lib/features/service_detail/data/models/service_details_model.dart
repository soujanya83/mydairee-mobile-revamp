// To parse this JSON data, do
//
//     final serviceDetailsResponse = serviceDetailsResponseFromJson(jsonString);

import 'dart:convert';

ServiceDetailsResponse serviceDetailsResponseFromJson(String str) => ServiceDetailsResponse.fromJson(json.decode(str));

String serviceDetailsResponseToJson(ServiceDetailsResponse data) => json.encode(data.toJson());

class ServiceDetailsResponse {
  bool? status;
  String? msg;
  ServiceDetailsData? data;

  ServiceDetailsResponse({
    this.status,
    this.msg,
    this.data,
  });

  factory ServiceDetailsResponse.fromJson(Map<String, dynamic> json) => ServiceDetailsResponse(
    status: json["status"],
    msg: json["msg"],
    data: json["data"] == null ? null : ServiceDetailsData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": data?.toJson(),
  };
}

class ServiceDetailsData {
  List<Center>? centers;
  ServiceDetails? serviceDetails;
  Center? selectedCenter;

  ServiceDetailsData({
    this.centers,
    this.serviceDetails,
    this.selectedCenter,
  });

  factory ServiceDetailsData.fromJson(Map<String, dynamic> json) => ServiceDetailsData(
    centers: json["centers"] == null ? [] : List<Center>.from(json["centers"]!.map((x) => Center.fromJson(x))),
    serviceDetails: json["serviceDetails"] == null ? null : ServiceDetails.fromJson(json["serviceDetails"]),
    selectedCenter: json["selectedCenter"] == null ? null : Center.fromJson(json["selectedCenter"]),
  );

  Map<String, dynamic> toJson() => {
    "centers": centers == null ? [] : List<dynamic>.from(centers!.map((x) => x.toJson())),
    "serviceDetails": serviceDetails?.toJson(),
    "selectedCenter": selectedCenter?.toJson(),
  };
}

class Center {
  int? id;
  dynamic userId;
  String? centerName;
  String? adressStreet;
  String? addressCity;
  String? addressState;
  String? addressZip;
  DateTime? createdAt;
  DateTime? updatedAt;

  Center({
    this.id,
    this.userId,
    this.centerName,
    this.adressStreet,
    this.addressCity,
    this.addressState,
    this.addressZip,
    this.createdAt,
    this.updatedAt,
  });

  factory Center.fromJson(Map<String, dynamic> json) => Center(
    id: json["id"],
    userId: json["user_id"],
    centerName: json["centerName"],
    adressStreet: json["adressStreet"],
    addressCity: json["addressCity"],
    addressState: json["addressState"],
    addressZip: json["addressZip"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "centerName": centerName,
    "adressStreet": adressStreet,
    "addressCity": addressCity,
    "addressState": addressState,
    "addressZip": addressZip,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class ServiceDetails {
  int? id;
  String? serviceName;
  String? serviceApprovalNumber;
  String? serviceStreet;
  String? serviceSuburb;
  String? serviceState;
  String? servicePostcode;
  String? contactTelephone;
  String? contactMobile;
  String? contactFax;
  String? contactEmail;
  String? providerContact;
  String? providerTelephone;
  String? providerMobile;
  String? providerFax;
  String? providerEmail;
  String? supervisorName;
  String? supervisorTelephone;
  String? supervisorMobile;
  String? supervisorFax;
  String? supervisorEmail;
  String? postalStreet;
  String? postalSuburb;
  String? postalState;
  String? postalPostcode;
  String? eduLeaderName;
  String? eduLeaderTelephone;
  String? eduLeaderEmail;
  String? strengthSummary;
  String? childGroupService;
  String? personSubmittingQip;
  String? educatorsData;
  String? philosophyStatement;
  int? centerid;

  ServiceDetails({
    this.id,
    this.serviceName,
    this.serviceApprovalNumber,
    this.serviceStreet,
    this.serviceSuburb,
    this.serviceState,
    this.servicePostcode,
    this.contactTelephone,
    this.contactMobile,
    this.contactFax,
    this.contactEmail,
    this.providerContact,
    this.providerTelephone,
    this.providerMobile,
    this.providerFax,
    this.providerEmail,
    this.supervisorName,
    this.supervisorTelephone,
    this.supervisorMobile,
    this.supervisorFax,
    this.supervisorEmail,
    this.postalStreet,
    this.postalSuburb,
    this.postalState,
    this.postalPostcode,
    this.eduLeaderName,
    this.eduLeaderTelephone,
    this.eduLeaderEmail,
    this.strengthSummary,
    this.childGroupService,
    this.personSubmittingQip,
    this.educatorsData,
    this.philosophyStatement,
    this.centerid,
  });

  factory ServiceDetails.fromJson(Map<String, dynamic> json) => ServiceDetails(
    id: json["id"],
    serviceName: json["serviceName"],
    serviceApprovalNumber: json["serviceApprovalNumber"],
    serviceStreet: json["serviceStreet"],
    serviceSuburb: json["serviceSuburb"],
    serviceState: json["serviceState"],
    servicePostcode: json["servicePostcode"],
    contactTelephone: json["contactTelephone"],
    contactMobile: json["contactMobile"],
    contactFax: json["contactFax"],
    contactEmail: json["contactEmail"],
    providerContact: json["providerContact"],
    providerTelephone: json["providerTelephone"],
    providerMobile: json["providerMobile"],
    providerFax: json["providerFax"],
    providerEmail: json["providerEmail"],
    supervisorName: json["supervisorName"],
    supervisorTelephone: json["supervisorTelephone"],
    supervisorMobile: json["supervisorMobile"],
    supervisorFax: json["supervisorFax"],
    supervisorEmail: json["supervisorEmail"],
    postalStreet: json["postalStreet"],
    postalSuburb: json["postalSuburb"],
    postalState: json["postalState"],
    postalPostcode: json["postalPostcode"],
    eduLeaderName: json["eduLeaderName"],
    eduLeaderTelephone: json["eduLeaderTelephone"],
    eduLeaderEmail: json["eduLeaderEmail"],
    strengthSummary: json["strengthSummary"],
    childGroupService: json["childGroupService"],
    personSubmittingQip: json["personSubmittingQip"],
    educatorsData: json["educatorsData"],
    philosophyStatement: json["philosophyStatement"],
    centerid: json["centerid"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "serviceName": serviceName,
    "serviceApprovalNumber": serviceApprovalNumber,
    "serviceStreet": serviceStreet,
    "serviceSuburb": serviceSuburb,
    "serviceState": serviceState,
    "servicePostcode": servicePostcode,
    "contactTelephone": contactTelephone,
    "contactMobile": contactMobile,
    "contactFax": contactFax,
    "contactEmail": contactEmail,
    "providerContact": providerContact,
    "providerTelephone": providerTelephone,
    "providerMobile": providerMobile,
    "providerFax": providerFax,
    "providerEmail": providerEmail,
    "supervisorName": supervisorName,
    "supervisorTelephone": supervisorTelephone,
    "supervisorMobile": supervisorMobile,
    "supervisorFax": supervisorFax,
    "supervisorEmail": supervisorEmail,
    "postalStreet": postalStreet,
    "postalSuburb": postalSuburb,
    "postalState": postalState,
    "postalPostcode": postalPostcode,
    "eduLeaderName": eduLeaderName,
    "eduLeaderTelephone": eduLeaderTelephone,
    "eduLeaderEmail": eduLeaderEmail,
    "strengthSummary": strengthSummary,
    "childGroupService": childGroupService,
    "personSubmittingQip": personSubmittingQip,
    "educatorsData": educatorsData,
    "philosophyStatement": philosophyStatement,
    "centerid": centerid,
  };
}