class Not {
  int notID;
  int katogoryID;
  String notBaslik;
  String notIcerik;
  String notTarih;
  int notOncelik;

  Not(this.katogoryID, this.notBaslik, this.notIcerik, this.notTarih,
      this.notOncelik); //verileri yazarken

  Not.withID(this.notID, this.katogoryID, this.notBaslik, this.notIcerik,
      this.notTarih, this.notOncelik); //verileri okurken

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['notID'] = notID;
    map['kategoryID'] = katogoryID;
    map['notBaslik'] = notBaslik;
    map['notIcerik'] = notIcerik;
    map['notTarih'] = notTarih;
    map['notOncelik'] = notOncelik;
  }

  Not.fromMap(Map<String, dynamic> map) {
    this.notID = map['notID'];
    this.katogoryID = map['kategoryID'];
    this.notBaslik = map['notBaslik'];
    this.notIcerik = map['notIcerik'];
    this.notTarih = map['notTarih'];
    this.notOncelik = map['notOncelik'];
  }

  @override
  String toString() {
    return 'Not{notID: $notID, kategoryID: $katogoryID, notBaslik: $notBaslik, notIcerik: $notIcerik, notTarih: $notTarih, notOncelik: $notOncelik}';
  }
}
