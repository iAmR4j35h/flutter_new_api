abstract class NewsEvent{
  const NewsEvent();
}

class NewsFetchEvent extends NewsEvent{
  final String search;
  final String categories;
  const NewsFetchEvent(this.search,this.categories);
}