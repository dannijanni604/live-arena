class SportsData {
  List<String> physicalSports = [
    "Breakdancing",
    "Cheerleading",
    "Competitive dancing",
    "Dancesport",
    "Dragon dance and Lion dance",
    "Freerunning",
    "Gymnastics",
    "High kick",
    "Parkour",
    "Pole sports",
    "Stunt",
    "Trampolining"
  ];
  List<String> airSports = [
    "Aerobatics",
    "Air racing",
    "Cluster ballooning",
    "Hopper ballooning",
    "Wingsuit flying",
    "Gliding",
    "Hang gliding",
    "Powered hang glider",
    "Human powered aircraft",
    "Model aircraft",
    "Parachuting",
    "Banzai skydiving",
    "BASE jumping",
    "Skysurfing",
    "Wingsuit flying",
    "Paragliding",
    "Powered paragliding",
    "Paramotoring",
    "Ultralight aviation"
  ];

  List<String> archery = [
    "Field archery",
    "Flight archery",
    "Gungdo",
    "Indoor archery",
    "Kyūdō",
    "Mounted archery",
    "Popinjay",
    "Run archery",
    "Target archery"
  ];

  List<String> get allSports =>
      (archery + airSports + physicalSports).toSet().toList();
}

class LanguagesData {
  final List<String> languages = [
    'English',
    'Spanish',
    'Arabic',
    'French',
    'Chinese',
    'Japanes',
    'Italian'
  ];
}
