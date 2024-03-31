String caesarCipherEncode(String input, int shift) {
  StringBuffer result = StringBuffer();
  for (int i = 0; i < input.length; i++) {
    String char = input[i];
    if (char.isNotEmpty && char != " ") {
      String encodedChar = String.fromCharCode(char.codeUnitAt(0) + shift);
      result.write(encodedChar);
    } else {
      result.write(char);
    }
  }
  return result.toString();
}

String caesarCipherDecode(String input, int shift) {
  // Decoding is the same as encoding but with a negative shift
  return caesarCipherEncode(input, -shift);
}

String getUserNameFromChache(String input) {
  String i = input.toString();
  List<String> parts = i.split('+');
  return parts.first.trim();
}

String makeCache(String u, String p){
  return u+"+"+p;
}

bool isPasswordOk(String x){
  if(x.length>=6) return true;
  else return false;
}