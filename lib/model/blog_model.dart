
import 'dart:convert';

Blog blogFromJson(String str) => Blog.fromJson(json.decode(str));

String blogToJson(Blog data) => json.encode(data.toJson());

class Blog {
    List<BlogElement>? blogs;

    Blog({
        this.blogs,
    });

    factory Blog.fromJson(Map<String, dynamic> json) => Blog(
        blogs: json["blogs"] == null ? [] : List<BlogElement>.from(json["blogs"]!.map((x) => BlogElement.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "blogs": blogs == null ? [] : List<dynamic>.from(blogs!.map((x) => x.toJson())),
    };
}

class BlogElement {
    String? id;
    String? imageUrl;
    String? title;

    BlogElement({
        this.id,
        this.imageUrl,
        this.title,
    });

    factory BlogElement.fromJson(Map<String, dynamic> json) => BlogElement(
        id: json["id"],
        imageUrl: json["image_url"],
        title: json["title"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "image_url": imageUrl,
        "title": title,
    };
}
