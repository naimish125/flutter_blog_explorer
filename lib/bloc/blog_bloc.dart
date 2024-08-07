import 'dart:async';

import 'package:flutter_blog_explorer/api/api.dart';
import 'package:flutter_blog_explorer/model/blog_model.dart';

class BlogBloc {
  StreamController<Blog> apiController = StreamController<Blog>.broadcast();
  Stream<Blog> get blogStream => apiController.stream;
  Blog? blog;

  void fetchData() async {
    try {
      blog = await BlogApi.fetchBlogs();
      apiController.sink.add(blog!);
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void dispose() {
    apiController.close();
  }
}

BlogBloc blogBloc = BlogBloc();
