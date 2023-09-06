
import 'package:cached_network_image/cached_network_image.dart';
import 'package:car_crash_list/models/car_news.dart';
import 'package:car_crash_list/utils/app_colors.dart';
import 'package:car_crash_list/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class NewsDetailPage extends StatelessWidget {
  final CarNews carNews;
  const NewsDetailPage({super.key,required this.carNews});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
      child: Scaffold(
        appBar: AppBar(
          title: Text(carNews.title),
        ),
        backgroundColor: AppColors.white,
        body: Column(
          children: [
            Hero(
              tag: carNews.image,
              child: AspectRatio(
                aspectRatio: 16/9,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(8)
                      ),
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(
                            carNews.image,
                          ),
                          fit: BoxFit.cover
                      )
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppConstants.pagePadding,
                vertical: 12
              ),
              child: HtmlWidget(
                carNews.content,
                textStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  height: 1.7
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
