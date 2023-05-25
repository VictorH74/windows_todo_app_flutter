import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit(): super(const ThemeState());
  void setThemeColor(ThemeColor color) => emit(ThemeState(themeColor: color));

}