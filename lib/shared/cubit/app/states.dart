
abstract class AppStates {}
// AppInitialState is a class that extends AppStates and has no properties.
class AppInitialState extends AppStates {}
// AppChangeBottomNavBarState is a class that extends AppStates and has a property index of type int.
class AppChangeBottomNavBarState extends AppStates {
  final int index;
  AppChangeBottomNavBarState(this.index);
}
// mode is a class that extends AppStates and has a property isDark of type bool.
class AppChangeModeState extends AppStates {
  final bool isDark;
  AppChangeModeState(this.isDark);
}
// AppCreateDataBaseState is a class that extends AppStates and has a property database.