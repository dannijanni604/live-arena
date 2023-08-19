class RecomendedArena {
  final String imag;
  final String streamTitle;
  final String streamCategory;
  final String streamTime;
  final String sportName;
  final String language;
  final String arenaViewer;

  const RecomendedArena({
    required this.imag,
    required this.streamTitle,
    required this.streamCategory,
    required this.streamTime,
    required this.sportName,
    required this.language,
    required this.arenaViewer,
  });

  static const List<RecomendedArena> recomendedArenaList = [
    RecomendedArena(
        imag: "assets\images\pic1.jpg",
        streamTitle: "Arena Title",
        streamCategory: "# Action",
        streamTime: "2 Hr Later",
        sportName: "Racing",
        arenaViewer: "480K",
        language: "English"),
    RecomendedArena(
        imag: "images/pic2.jpg",
        streamTitle: "Arena Title",
        streamCategory: "# Drama",
        streamTime: "2 hr later",
        arenaViewer: "480K",
        sportName: "Hockey",
        language: "English"),
    RecomendedArena(
        imag: "images/pic3.jpg",
        streamTitle: "Arena Title",
        streamCategory: "# Story",
        streamTime: "2 hr later",
        arenaViewer: "480K",
        sportName: "Match",
        language: "English"),
    RecomendedArena(
        imag: "images/pic4.jpg",
        streamTitle: "Arena Title",
        streamCategory: "# Horror",
        streamTime: "2 Hr Later",
        arenaViewer: "480K",
        sportName: "Movie",
        language: "English"),
    RecomendedArena(
        imag: "assets/images/pic5.jpg",
        streamTitle: "Arena Title",
        streamCategory: "Romantic",
        streamTime: "# In 2 mint",
        sportName: "Drama",
        arenaViewer: "480K",
        language: "English"),
    RecomendedArena(
        imag: "assets/images/pic6.jpg",
        streamTitle: "Arena Title",
        streamCategory: "# Action",
        streamTime: "After 2Hr",
        arenaViewer: "480K",
        sportName: "FootBall",
        language: "English"),
    RecomendedArena(
        imag: "assets/images/pic7.jpeg",
        streamTitle: "Arena Title",
        streamCategory: "# Horror",
        streamTime: "2 hr later",
        sportName: "FootBall",
        arenaViewer: "480K",
        language: "English"),
    RecomendedArena(
        imag: "assets/images/pic8.png",
        streamTitle: "# Esports",
        streamCategory: "# Sports",
        streamTime: "After 2Hr",
        sportName: "FootBall",
        arenaViewer: "480K",
        language: "English"),
    RecomendedArena(
        imag: "images/pic9.png",
        streamTitle: "Arena Title",
        streamCategory: "Arena Category",
        streamTime: "2 hr later",
        sportName: "FootBall",
        arenaViewer: "480K",
        language: "English"),
    RecomendedArena(
        imag: "images/pic10.jpg",
        streamTitle: "Arena Title",
        streamCategory: "Arena Category",
        streamTime: "2 Hr Later",
        arenaViewer: "480K",
        sportName: "FootBall",
        language: "English"),
  ];

  static const List<RecomendedArena> liveStram = [
    RecomendedArena(
        imag: "images/pic2.jpg",
        streamTitle: "Arena Title",
        streamCategory: "# Drama",
        streamTime: "2 hr later",
        arenaViewer: "480K",
        sportName: "Hockey",
        language: "English"),
    RecomendedArena(
        imag: "images/pic3.jpg",
        streamTitle: "Arena Title",
        streamCategory: "# Story",
        streamTime: "2 hr later",
        arenaViewer: "480K",
        sportName: "Match",
        language: "English"),
    RecomendedArena(
        imag: "images/pic4.jpg",
        streamTitle: "Arena Title",
        streamCategory: "# Horror",
        streamTime: "2 Hr Later",
        arenaViewer: "480K",
        sportName: "Movie",
        language: "English"),
    RecomendedArena(
        imag: "assets/images/pic5.jpg",
        streamTitle: "Arena Title",
        streamCategory: "Romantic",
        streamTime: "# In 2 mint",
        sportName: "Drama",
        arenaViewer: "480K",
        language: "English"),
    RecomendedArena(
        imag: "assets/images/pic6.jpg",
        streamTitle: "Arena Title",
        streamCategory: "# Action",
        streamTime: "After 2Hr",
        arenaViewer: "480K",
        sportName: "FootBall",
        language: "English"),
    RecomendedArena(
        imag: "assets/images/pic7.jpeg",
        streamTitle: "Arena Title",
        streamCategory: "# Horror",
        streamTime: "2 hr later",
        sportName: "FootBall",
        arenaViewer: "480K",
        language: "English"),
    RecomendedArena(
        imag: "assets/images/pic8.png",
        streamTitle: "# Esports",
        streamCategory: "# Sports",
        streamTime: "After 2Hr",
        sportName: "FootBall",
        arenaViewer: "480K",
        language: "English"),
  ];
}
