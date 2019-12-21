bool isValidUsername(String name) {
  return name != null && name != '' && !isValidNumeric(name);
}

bool isValidName(String name) {
  return name != null &&
      name != '' &&
      name.contains(new RegExp(r'^[a-zA-Z ]*$'));
}

bool isValidCost(String cost) {
  return cost != null && cost != '' && isValidNumeric(cost);
}

bool isValidNumeric(String s) {
  return s != null && double.tryParse(s) != null && double.parse(s) >= 0;
}
