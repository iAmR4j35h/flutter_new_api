import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/bloc/news_state.dart';
import 'package:news_app/bloc/news_events.dart';
import 'package:news_app/bloc/news_repo.dart';
import 'dart:async';

class NewsBloc extends Bloc<NewsFetchEvent,NewsState>{
  final NewsRepo newsRepo;
  int page=1;
  bool isFetching=false;

  NewsBloc({@required this.newsRepo}):super(NewsInitialState());

  @override
  Stream<NewsState> mapEventToState(NewsFetchEvent event)async* {
    if (event is NewsFetchEvent) {
      yield NewsLoadingState(message: "Loading news...");
      print("Loading event state api fetching");
      final response = await newsRepo.getNews(search: event.search, page: page, categories: event.categories);
      if (response.status == "ok") {
        yield NewsSuccessState(news: response.articles);
        page++;
      }
      else {
        yield NewsErrorState(message: response.status);
      }
    }
  }

}