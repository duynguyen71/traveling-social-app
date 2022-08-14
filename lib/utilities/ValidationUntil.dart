class ValidationUntil {
 static  bool isNumber(String? str) {
    if(str==null) return false;
    return double.tryParse(str) != null;
  }
}
