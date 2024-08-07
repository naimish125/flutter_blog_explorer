import 'package:flutter/material.dart';
import 'package:flutter_blog_explorer/bloc/blog_bloc.dart';
import 'package:flutter_blog_explorer/model/blog_model.dart';
import 'package:flutter_blog_explorer/screen/detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LikedBlogsScreen extends StatefulWidget {
  const LikedBlogsScreen({super.key});

  @override
  State<LikedBlogsScreen> createState() => _LikedBlogsScreenState();
}

class _LikedBlogsScreenState extends State<LikedBlogsScreen> {
  List<String> likedBlogIds = [];
  List<BlogElement> likedBlogs = [];
  bool isLoading = true; 

  @override
  void initState() {
    super.initState();
    loadLikedBlogs();
  }

  Future<void> loadLikedBlogs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      likedBlogIds = prefs.getStringList('likedBlogs') ?? [];
    });
    fetchLikedBlogs();
  }

  Future<void> fetchLikedBlogs() async {
    blogBloc.fetchData();
    blogBloc.blogStream.listen((blogData) {
      final allBlogs = blogData.blogs ?? [];
      setState(() {
        likedBlogs = allBlogs.where((blog) => likedBlogIds.contains(blog.id)).toList();
        isLoading = false; // Set loading to false after data is fetched
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff212121),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Liked Blogs',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff212121),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
               color: Colors.white, 
              ),
            )
          : ListView.builder(
              itemCount: likedBlogs.length,
              itemBuilder: (context, index) {
                final blog = likedBlogs[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(blog: blog),
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.black45,
                    child: ListTile(
                      leading: blog.imageUrl != null
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(blog.imageUrl!),
                            )
                          : null,
                      title: Text(
                        blog.title ?? 'No Title',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
