import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_app/network/news_data_response_model.dart';

class NewsCard extends StatelessWidget {
  Articles item;
  bool isCardView;
  Function onClick;

  NewsCard(this.item, this.isCardView,this.onClick);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:onClick ,
      child: Card(
        child: Column(
          children: [
            if (isCardView &&item.urlToImage!=null) Image.network(item.urlToImage, height: 300,fit: BoxFit.cover,),
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0, top: 20, left: 24.0, right: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (item.author != null)
                        Expanded(
                          child: Chip(
                            labelPadding: EdgeInsets.symmetric(horizontal: 10),
                            label: Text(
                              item.author,
                              style: TextStyle(color: Colors.grey),
                            ),
                            backgroundColor: Colors.white,
                            shape: StadiumBorder(side: BorderSide(color: Colors.grey)),
                            padding: EdgeInsets.symmetric(horizontal: 12),
                          ),
                        ),
                      Spacer(),
                      if (item.source.name != null)
                        Chip(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          label: Text(
                            item.source.name,
                            style: TextStyle(color: Colors.green),
                          ),
                          backgroundColor: Colors.white,
                          shape: StadiumBorder(side: BorderSide(color: Colors.green)),
                        )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    item.title,
                    style: TextStyle(fontFamily: "TimesNew", fontSize: 30),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  if (!isCardView && item.description!=null)
                    Text(
                      item.description,
                      style: TextStyle(color: Colors.blueGrey, fontSize: 16),
                    ),
                  if (!isCardView)
                    SizedBox(
                      height: 15,
                    ),
                  Text(
                    "UPDATED "+DateFormat("MMMM dd yyyy").format(DateFormat("yyyy-MM-dd'T'hh:mm:ss'Z'").parse(item.publishedAt)).toUpperCase(),
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
