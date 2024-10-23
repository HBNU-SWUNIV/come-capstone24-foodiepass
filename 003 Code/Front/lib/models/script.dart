class Script {
  final String profileScript, destinationScript;

  Script.fromJson(Map<String, dynamic> json)
      : profileScript = json['profileScript'],
        destinationScript = json['destinationScript'];
}