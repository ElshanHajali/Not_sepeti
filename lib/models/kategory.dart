class Kategory {
  int katogoryID;
  String kategoryBaslik;

  Kategory(
      this.kategoryBaslik); // kategory eklerken cunki ID DB tarafinda olusur

  Kategory.withID(this.katogoryID,
      this.kategoryBaslik); //kategoryler db den okurken kullanilir

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['katogoryID'] = katogoryID;
    map['kategoryBaslik'] = kategoryBaslik;

    return map;
  }

  Kategory.fromMap(Map<String, dynamic> map) {
    this.katogoryID = map['katogoryID'];
    this.kategoryBaslik = map['kategoryBaslik'];
  }

  @override
  String toString() {
    return 'Kategory{katogoryID: $katogoryID, kategoryBaslik: $kategoryBaslik}';
  }
}
