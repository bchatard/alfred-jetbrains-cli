enum JetBrainsProduct {
  androidStudio,
  appCode,
  aqua,
  cLion,
  dataGrip,
  dataSpell,
  fleet,
  // gateway,
  goLand,
  intelliJIdeaCommunity,
  intelliJIdeaUltimate,
  phpStorm,
  pyCharmProfessional,
  pyCharmCommunity,
  rider,
  rubyMine,
  rustRover,
  webStorm,
}

extension JetBrainsProductString on String {
  String toJbName() {
    final stringBuffer = StringBuffer();

    var capitalizeNext = true;
    for (final letter in codeUnits) {
      // UTF-16: A-Z => 65-90, a-z => 97-122.
      if (capitalizeNext && letter >= 97 && letter <= 122) {
        stringBuffer.writeCharCode(letter - 32);
        capitalizeNext = false;
      } else {
        // UTF-16: 32 == space, 46 == period
        if (letter == 32 || letter == 46) capitalizeNext = true;
        stringBuffer.writeCharCode(letter);
      }
    }

    return stringBuffer.toString();
  }
}
