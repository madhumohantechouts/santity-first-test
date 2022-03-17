class DataResponse {
  String? sCreatedAt;
  String? sId;
  String? sRev;
  String? sType;
  String? sUpdatedAt;
  String? emailId;
  ImageT? image;
  int? phoneNo;
  String? userName;

  DataResponse({this.sCreatedAt, this.sId, this.sRev, this.sType, this.sUpdatedAt, this.emailId, this.image, this.phoneNo, this.userName});

  DataResponse.fromJson(Map<String, dynamic> json) {
    sCreatedAt = json['_createdAt'];
    sId = json['_id'];
    sRev = json['_rev'];
    sType = json['_type'];
    sUpdatedAt = json['_updatedAt'];
    emailId = json['emailId'];
    image = json['image'] != null ? ImageT.fromJson(json['image']) : null;
    phoneNo = json['phoneNo'];
    userName = json['userName'];
  }

  @override
  String toString() {
    return 'DataResponse{sCreatedAt: $sCreatedAt, sId: $sId, sRev: $sRev, sType: $sType, sUpdatedAt: $sUpdatedAt, emailId: $emailId, image: $image, phoneNo: $phoneNo, userName: $userName}';
  }
}

class ImageT {
  String? sType;
  AssetT? assett;
  String? url;

  ImageT({this.sType, this.assett, this.url});

  ImageT.fromJson(Map<String, dynamic> json) {
    sType = json['_type'];
    assett = json['asset'] != null ? AssetT.fromJson(json['asset']) : null;
  }

  @override
  String toString() {
    return 'Image{sType: $sType, asset: $assett}';
  }
}

class AssetT {
  String? sRef;
  String? sType;

  AssetT({this.sRef, this.sType});

  AssetT.fromJson(Map<String, dynamic> json) {
    sRef = json['_ref'];
    sType = json['_type'];
  }

  @override
  String toString() {
    return 'Asset{sRef: $sRef, sType: $sType}';
  }
}
