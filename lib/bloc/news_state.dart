import 'package:flutter/material.dart';
import 'package:news_app/network/news_data_response_model.dart';

abstract class NewsState{
const NewsState();
}

class NewsInitialState extends NewsState{
  const NewsInitialState();
}

class NewsLoadingState extends NewsState{
  final String message;
  const NewsLoadingState({@required this.message});
}
class NewsErrorState extends NewsState{
  final String message;
  const NewsErrorState({@required this.message});
}

class NewsSuccessState extends NewsState{
  final List<Articles> news;
  const NewsSuccessState({@required this.news});
}