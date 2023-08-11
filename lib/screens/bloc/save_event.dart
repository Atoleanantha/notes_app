abstract class SaveEvent{}

class SaveTitleChangeEvent extends SaveEvent{
  SaveTitleChangeEvent(this.titleV, this.descriptionV);
  String titleV;
  String descriptionV;
}
class SaveSubmiteEvent extends SaveEvent{
  SaveSubmiteEvent(this.title, this.description);
  String title;
  String description;
}
