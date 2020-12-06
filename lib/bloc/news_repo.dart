import 'package:flutter/cupertino.dart';
import 'package:news_app/network/api_provider.dart';
import 'package:news_app/network/news_data_response_model.dart';

class NewsRepo {
  static final NewsRepo _newsRepo = NewsRepo._();
  static const int _perPage = 10;
  static final apiProvider = ApiProvider();

  NewsRepo._();

  factory NewsRepo() {
    return _newsRepo;
  }

  Future<NewsDataResponse> getNews({@required  String search, @required int page, @required String categories}) async {
    print("fetch news data");


    return NewsDataResponse.fromJson( await apiProvider.get(
        "/top-headlines?country=in&apiKey=2a08c16092014a3e9e417388281804f2&pageSize=$_perPage&page=$page&q=$search&category=${categories}"));
  }
}
