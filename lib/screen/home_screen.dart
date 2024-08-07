import 'package:flutter/material.dart';
import 'package:flutter_blog_explorer/bloc/blog_bloc.dart';
import 'package:flutter_blog_explorer/model/blog_model.dart';
import 'package:flutter_blog_explorer/screen/detail_screen.dart';
import 'package:flutter_blog_explorer/screen/likeblog_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> likedBlogs = [];

  @override
  void initState() {
    super.initState();
    blogBloc.fetchData();
    loadLikedBlogs();
  }

  Future<void> loadLikedBlogs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      likedBlogs = prefs.getStringList('likedBlogs') ?? [];
    });
  }

  Future<void> toggleLike(String blogId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (likedBlogs.contains(blogId)) {
        likedBlogs.remove(blogId);
      } else {
        likedBlogs.add(blogId);
      }
      prefs.setStringList('likedBlogs', likedBlogs);
    });
  }


    void shareBlog(BlogElement blog) {
    final text = 'Check out this blog: ${blog.title}\n\n${blog.imageUrl}';
    Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff212121),
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LikedBlogsScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.bookmark_border,
                  color: Colors.white,
                ))
          ],
          title: const Text(
            "Blogs and Articles",
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
          backgroundColor: const Color(0xff212121),
          centerTitle: true,
        ),
        body: StreamBuilder<Blog>(
          stream: blogBloc.blogStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var blogs = snapshot.data!.blogs;

              return ListView.builder(
                itemCount: blogs?.length ?? 0,
                itemBuilder: (context, index) {
                  final blog = blogs![index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(
                            blog: blog,
                          ),
                        ),
                      );
                    },
                    child: Stack(clipBehavior: Clip.none, children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 2, bottom: 2),
                        child: Card(
                          color: Colors.black45,
                          child: ListTile(
                            leading: blog.imageUrl != null
                                ? CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(blog.imageUrl!),
                                  )
                                : null,
                            title: Text(
                              blog.title ?? 'No Title',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 38,
                        bottom: -6,
                        child: IconButton(
                          onPressed: () {
                            if (blog.id != null) {
                              toggleLike(blog.id!); 
                            }
                          },
                          icon: Icon(
                            likedBlogs.contains(blog.id)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: likedBlogs.contains(blog.id)
                                ? Colors.red
                                : Colors.white,
                          ),
                        ),
                      ),

                       Positioned(
                        right: 8,
                        bottom: -6,
                        child: IconButton(
                          onPressed: () {
                         shareBlog(blog);
                          },
                          icon: const Icon(
                          Icons.share,
                          color: Colors.white,
                          ),
                        ),
                      ),
                    ]),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
