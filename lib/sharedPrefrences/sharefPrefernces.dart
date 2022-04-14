import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenc {
  String UID = "uid";
  String FNAME = "fname";
  String LNAME = "lname";
  String EMAIL = "email";
  String PHOTOURL = "photourl";
  String PHONE = "phone";
  String ACCID = "accid";
  String REFEREDBY = "refered_by";
  String INFOPAGE = "infopage";
  String TOTALAMT = "totalamt";
  String OPTION_PAGE = "Option Page";
  String EXPANSESTARTED = "Expanse Started";
  String PACKAGEDONE = "Package Done";
  String SERVERVERIFICATION = "Server Verification";
  String DATETIMEINSTRUMENT = "DateTime";
  String WALLET = "Wallet";
  String USERTYPE = "Usertype";

  setUid(String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(UID, uid);
  }

  setFName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(FNAME, name);
  }

  setLName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(LNAME, name);
  }

  setEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(EMAIL, email);
  }

  setPhotoUrl(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(PHOTOURL, url);
  }

  setPhoneNumber(String ph) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(PHONE, ph);
  }

  setAccId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(ACCID, id);
  }

  setTotalAmount(String amt) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(TOTALAMT, amt);
  }

  setReferedBy(String rb) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(REFEREDBY, rb);
  }

  setInfoPage(String ip) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(INFOPAGE, ip);
  }

  setCertificateNumber(String cn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(OPTION_PAGE, cn);
  }

  setPackageDone(bool pp) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(PACKAGEDONE, pp);
  }

  setServerVerification(int pp) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(SERVERVERIFICATION, pp);
  }

  setInstrumentdate(String pp) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(DATETIMEINSTRUMENT, pp);
  }

  setWallet(String pp) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(WALLET, pp);
  }

  setUserType(String usertype) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(USERTYPE, usertype);
  }

  Future<String> getUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String val = prefs.getString(USERTYPE);
    return val;
  }

  Future<String> getWallet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String val = prefs.getString(WALLET);
    return val;
  }

  Future<String> getInstrumentDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String val = prefs.getString(DATETIMEINSTRUMENT);
    return val;
  }

  Future<int> getServerVerification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int val = prefs.getInt(SERVERVERIFICATION);
    return val;
  }

  Future<bool> getPackageDone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool val = prefs.getBool(PACKAGEDONE);
    return val;
  }

  Future<String> getCertificateNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String val = prefs.getString(OPTION_PAGE);
    return val;
  }

  Future<String> getUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String val = prefs.getString(UID);
    return val;
  }

  Future<String> getFName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(FNAME);
  }

  Future<String> getLName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(LNAME);
  }

  Future<String> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(EMAIL);
  }

  Future<String> getPhotoUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(PHOTOURL);
  }

  Future<String> getPhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(PHONE);
  }

  Future<String> getACCID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(ACCID);
  }

  Future<String> getTotalAmt() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(TOTALAMT);
  }

  Future<String> getReferedBy() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(REFEREDBY);
  }

  Future<String> getInfoPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(INFOPAGE);
  }

  removePref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(UID);
    prefs.remove(FNAME);
    prefs.remove(LNAME);
    prefs.remove(EMAIL);
    prefs.remove(PHOTOURL);
  }
}
