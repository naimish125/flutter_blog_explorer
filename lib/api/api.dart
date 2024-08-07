import 'dart:convert';

import 'package:flutter_blog_explorer/model/blog_model.dart';
import 'package:http/http.dart' as http;

class BlogApi {
  static Future<Blog> fetchBlogs() async {
    final String url = 'https://intent-kit-16.hasura.app/api/rest/blogs';
    final String adminSecret = '32qR4KmXOIpsGPQKMqEJHGJS27G5s7HdSKO3gdtQd2kv5e852SiYwWNfxkZOBuQ6';

    try {
      var headers = {
        'x-hasura-admin-secret': adminSecret,
      };
      var request = http.Request('GET', Uri.parse(url));
      request.headers.addAll(headers);

      http.Response response = await http.Response.fromStream(await request.send());
      print('---------------------->response.body===>${response.body}');

      if (response.statusCode == 200) {
        return Blog.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load blogs: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching blogs: $e');
      throw Exception('Failed to load blogs: $e');
    }
  }
}
