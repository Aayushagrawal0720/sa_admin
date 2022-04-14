// import 'package:get_storage/get_storage.dart';
//
// class GetStorageClas {
//   final store = GetStorage();
//
//   String UID = "uid";
//   String NAME = "name";
//   String EMAIL = "email";
//   String PHOTOURL = "photourl";
//   String PHONE = "phone";
//   String REFEREDBY = "refered_by";
//   String INFOPAGE = "infopage";
//   String CERTIFICATE = "Certificate";
//   String PACKAGEDONE = "Package Done";
//   String SERVERVERIFICATION = "Server Verification";
//   String DATETIMEINSTRUMENT = "DateTime";
//
//   setUid(String uid) async {
//     store.write(UID, uid);
//   }
//
//   setName(String name) async {
//     store.write(NAME, name);
//   }
//
//   setEmail(String email) async {
//     store.write(EMAIL, email);
//   }
//
//   setPhotoUrl(String url) async {
//     store.write(PHOTOURL, url);
//   }
//
//   setPhoneNumber(String ph) async {
//     store.write(PHONE, ph);
//   }
//
//   setReferedBy(String rb) async {
//     store.write(REFEREDBY, rb);
//   }
//
//   setInfoPage(String ip) async {
//     store.write(INFOPAGE, ip);
//   }
//
//   setCertificateNumber(String cn) async {
//     store.write(CERTIFICATE, cn);
//   }
//
//   setPackageDone(bool pp) async {
//     store.write(PACKAGEDONE, pp);
//   }
//
//   setServerVerification(int pp) async {
//     await store.write(SERVERVERIFICATION, pp);
//   }
//
//   setInstrumentdate(String pp) async {
//     store.write(DATETIMEINSTRUMENT, pp);
//   }
//
//   String getInstrumentDate() {
//     String val = "false";
//     if (store.read(DATETIMEINSTRUMENT) != null) {
//       val = store.read(DATETIMEINSTRUMENT);
//     }
//     return val;
//   }
//
//   int getServerVerification() {
//     int val = 0;
//     if (store.read(SERVERVERIFICATION) != null) {
//       val = store.read(SERVERVERIFICATION);
//     }
//     return val;
//   }
//
//   bool getPackageDone() {
//     bool val = false;
//     if (store.read(PACKAGEDONE) != null) {
//       val = store.read(PACKAGEDONE);
//     }
//     return val;
//   }
//
//   String getCertificateNumber() {
//     String val = "false";
//     if (store.read(CERTIFICATE) != null) {
//       val = store.read(CERTIFICATE);
//     }
//     return val;
//   }
//
//   String getUid() {
//     String val = "false";
//     if (store.read(UID) != null) {
//       val = store.read(UID);
//     }
//     return val;
//   }
//
//   String getName() {
//     String val = "false";
//     if (store.read(NAME) != null) {
//       val = store.read(NAME);
//     }
//     return val;
//   }
//
//   String getEmail() {
//     String val = "false";
//     if (store.read(EMAIL) != null) {
//       val = store.read(EMAIL);
//     }
//     return val;
//   }
//
//   String getPhotoUrl() {
//     String val =
//         "https://firebasestorage.googleapis.com/v0/b/stockadvisory-f4983.appspot.com/o/profile_photo%2Fperson.png?alt=media&token=8633f6ac-c739-441e-a425-59311f2f8373";
//     if (store.read(PHOTOURL) != null || store.read(PHOTOURL) != "") {
//       val = store.read(PHOTOURL);
//     }
//     return val;
//   }
//
//   String getPhoneNumber() {
//     String val = "false";
//     if (store.read(PHONE) != null) {
//       val = store.read(PHONE);
//     }
//     return val;
//   }
//
//   String getReferedBy() {
//     String val = "false";
//     if (store.read(REFEREDBY) != null) {
//       val = store.read(REFEREDBY);
//     }
//     return val;
//   }
//
//   Future<String> getInfoPage() async {
//     String val = "false";
//     if (store.read(INFOPAGE) != null) {
//       val = store.read(INFOPAGE);
//     }
//     return val;
//   }
//
//   deleteStorage() async {
//     store.erase();
//   }
// }
