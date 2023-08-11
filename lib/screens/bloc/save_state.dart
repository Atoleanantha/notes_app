abstract class SaveState{}

class SaveInitialState extends SaveState{}
class SaveValidState extends SaveState{}
class SaveErrorState extends SaveState{
  SaveErrorState(this.error);
  final String error;
}
class SaveLoadingState extends SaveState{

}