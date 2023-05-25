part of 'theme_cubit.dart';

enum ThemeColor {
  blue, // 1
  palePlum, // 2
  paleVioletRed, // 3
  lightCarminePink, // 4
  seaGreen, // 5
  pearlAqua, // 6
  lavenderGrey, // 7
  softCyan, // 8
  electricLavender, // 9
  pink, // 10
  peachPuff, // 11
  limeGreen, // 12
  celeste, // 13
  silver, // 14
}

class ThemeState extends Equatable {
  const ThemeState({this.themeColor = ThemeColor.blue});

  final ThemeColor themeColor;

  @override
  List<Object?> get props => throw UnimplementedError();
}
