class Script {
  final String profileScript, destinationScript;

  Script.fromJson(Map<String, dynamic> json)
      : profileScript = json['userScript'],
        destinationScript = json['originScript'];
}