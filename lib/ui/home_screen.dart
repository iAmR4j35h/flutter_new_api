import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/bloc/news_state.dart';
import 'package:news_app/bloc/news_bloc.dart';
import 'package:news_app/bloc/news_events.dart';
import 'package:news_app/bloc/news_repo.dart';
import 'package:news_app/components/news_card.dart';
import 'package:news_app/network/news_data_response_model.dart';
import 'package:news_app/ui/news_web_view.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var selectedCategory = "";
  var searchResult = "";
  TextEditingController searchController;
  final listCategories = [

    "business",
    "entertainment",
    "general",
    "health",
    "science",
    "sports",
    "technology"
  ];

  var isCardiew = true;
  var isSearchVisible = false;
  var isfilterVisible = false;

  var newsList = List<Articles>();

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    searchController = TextEditingController();
    searchController.addListener(() {
      print(searchController.text + " printing data");
    });
  }

  BuildContext blocContext;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewsBloc(newsRepo: NewsRepo())..add(NewsFetchEvent("", "")),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Center(
              child: Row(
            children: [
              Text("New APi", style: TextStyle(color: Colors.black54, fontSize: 24, fontWeight: FontWeight.bold)),
              Spacer(),
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.filter_alt,
                    color: Colors.black45,
                  ),
                ),
                onTap: () {
                  setState(() {
                    isfilterVisible = !isfilterVisible;
                  });
                },
              ),
              SizedBox(
                width: 10,
              ),
              isCardiew
                  ? InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.filter,
                          color: Colors.black45,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          isCardiew = false;
                        });
                      },
                    )
                  : InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.list,
                          color: Colors.black45,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          isCardiew = true;
                        });
                      },
                    ),
              SizedBox(
                width: 10,
              ),
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.search,
                    color: Colors.black45,
                  ),
                ),
                onTap: () {
                  setState(() {
                    isSearchVisible = !isSearchVisible;
                  });
                },
              ),
            ],
          )),
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.max, children: [
            if (isfilterVisible)
              Card(
                child: Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                      children: listCategories
                          .map((e) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: ChoiceChip(
                                label: Text(e),
                                selected: selectedCategory == e,
                                onSelected: (bool selected) {
                                  setState(() {
                                    if (selectedCategory == e) {
                                      selectedCategory = "";
                                    } else {
                                      selectedCategory = e;
                                    }
                                    newsList.clear();
                                    blocContext.bloc<NewsBloc>()
                                      ..page = 1
                                      ..isFetching = true
                                      ..add(NewsFetchEvent(searchController.text, selectedCategory));
                                  });
                                },
                              )))
                          .toList()),
                ),
              ),
            if (isSearchVisible)
              SizedBox(
                height: 20,
              ),
            if (isSearchVisible)
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: searchController,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(8.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: "Search News ...",
                          hintStyle: TextStyle(color: Color(0xff828282))),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  FlatButton(
                    color: Colors.blue,
                    onPressed: () {
                      newsList.clear();
                      blocContext.bloc<NewsBloc>()
                        ..page = 1
                        ..isFetching = true
                        ..add(NewsFetchEvent(searchController.text, selectedCategory));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Search",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.blue,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                  )
                ],
              ),
            SizedBox(
              height: 20,
            ),
            // if(searchResult.isNotEmpty)
            // Text("Search result for \"$searchResult\""),
            Expanded(
              child: BlocConsumer<NewsBloc, NewsState>(
                builder: (context, state) {
                  blocContext = context;
                  if (state is NewsInitialState || state is NewsLoadingState && newsList.isEmpty) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is NewsSuccessState) {
                    newsList.addAll(state.news);
                    context.bloc<NewsBloc>().isFetching = false;
                  } else if (state is NewsErrorState && newsList.isEmpty) {
                    return Center(child: Text("Error -  ${state.message}"),);
                  }
                  return Stack(
                    children: [
                      ListView.separated(
                        shrinkWrap: true,
                        controller: _scrollController
                          ..addListener(() {
                            if (_scrollController.offset == _scrollController.position.maxScrollExtent &&
                                !context.bloc<NewsBloc>().isFetching) {
                              context.bloc<NewsBloc>()
                                ..isFetching = true
                                ..add(NewsFetchEvent(searchController.text, selectedCategory));
                            }
                          }),
                        itemCount: newsList.length,
                        itemBuilder: (context, index) => NewsCard(newsList[index], isCardiew,(){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => NewsWebView(url:newsList[index].url,title:newsList[index].title)),
                          );
                        }),
                        separatorBuilder: (context, index) => SizedBox(
                          height: 20,
                        ),
                      ),
                     if( state is NewsLoadingState && newsList.isNotEmpty)
                      Center(child: CircularProgressIndicator())

                    ],
                  );
                },
                listener: (context, state) {
                  if (state is NewsLoadingState) {
                    // Scaffold.of(context).showSnackBar(SnackBar(content: Text("Loading...")));
                  } else if (state is NewsSuccessState && state.news.isEmpty) {
                    Scaffold.of(context).showSnackBar(SnackBar(content: Text("No More news...")));
                  } else if (state is NewsErrorState) {
                    Scaffold.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                    context.bloc<NewsBloc>().isFetching = false;
                  }
                },
              ),
            )
          ]),
        )),
      ),
    );
  }
}
