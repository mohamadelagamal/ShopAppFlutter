
abstract class SearchStates {}

class SearchInitialState extends SearchStates {}
//
class SearchLoadingState extends SearchStates {}
//
class SearchSuccessState extends SearchStates {}
//
class SearchErrorState extends SearchStates {}
//
class SearchChangeIndexState extends SearchStates {
  final int index;

  SearchChangeIndexState(this.index);
}
