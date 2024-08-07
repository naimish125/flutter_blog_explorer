import 'package:flutter/material.dart';
import 'package:flutter_blog_explorer/model/blog_model.dart';

class DetailScreen extends StatefulWidget {
  final BlogElement blog;

  const DetailScreen({super.key, required this.blog});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text(
              "Blogs and Articles",
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
            backgroundColor: const Color(0xff212121),
          ),
          backgroundColor: const Color(0xff212121),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  Container(
                    child: widget.blog.imageUrl != null
                        ? Image.network(
                            widget.blog.imageUrl!,
                            fit: BoxFit.fill,
                          )
                        : Container(),
                  ),
                  const SizedBox(height: 13),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.blog.title ?? 'No Title',
                          style: const TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
