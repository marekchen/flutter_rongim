part of flutter_rongim;

String getListType(Type) {
  String typeString = Type.toString();
  if (typeString.startsWith("List")) {
    String typeString = Type.toString();
    return typeString.substring(5, typeString.length - 1);
  } else {
    return null;
  }
}