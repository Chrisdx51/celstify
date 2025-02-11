import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'comments_page.dart';

class SocialFeedScreen extends StatefulWidget {
  const SocialFeedScreen({Key? key}) : super(key: key);

  @override
  _SocialFeedScreenState createState() => _SocialFeedScreenState();
}

class _SocialFeedScreenState extends State<SocialFeedScreen> {
  List<Map<String, dynamic>> posts = [];

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final storedPosts = prefs.getString('posts');
    if (storedPosts != null) {
      setState(() {
        posts = List<Map<String, dynamic>>.from(json.decode(storedPosts));
      });
    }
  }

  Future<void> _savePosts() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('posts', json.encode(posts));
  }

  void _addPost(String text, String? imagePath) {
    setState(() {
      posts.add({
        'text': text,
        'image': imagePath,
        'likes': false,
        'likeCount': 0,
        'pinned': false,
      });
    });
    _savePosts();
  }

  void _deletePost(int index) {
    setState(() {
      posts.removeAt(index);
    });
    _savePosts();
  }

  void _toggleLike(int index) {
    setState(() {
      if (posts[index]['likes']) {
        posts[index]['likeCount'] = (posts[index]['likeCount'] ?? 1) - 1;
      } else {
        posts[index]['likeCount'] = (posts[index]['likeCount'] ?? 0) + 1;
      }
      posts[index]['likes'] = !posts[index]['likes'];
    });
    _savePosts();
  }

  void _togglePin(int index) {
    setState(() {
      posts[index]['pinned'] = !posts[index]['pinned'];
    });
    _savePosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eternal Stream'),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CommentsPage(
                        username: 'User $index',
                        postText: post['text'],
                        postImage: post['image'],
                      ),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text('User $index', style: const TextStyle(fontWeight: FontWeight.bold)),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deletePost(index),
                        ),
                      ),
                      if (post['image'] != null)
                        Image.file(
                          File(post['image']),
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(post['text']),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => _toggleLike(index),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: post['likes'] ? Colors.yellow : Colors.grey,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${post['likeCount'] ?? 0}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.comment_outlined),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CommentsPage(
                                      username: 'User $index',
                                      postText: post['text'],
                                      postImage: post['image'],
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                post['pinned'] == true
                                    ? Icons.push_pin
                                    : Icons.push_pin_outlined,
                                color: post['pinned'] == true ? Colors.blue : Colors.grey,
                              ),
                              onPressed: () => _togglePin(index),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ChatBar(onAddPost: _addPost),
          ),
        ],
      ),
    );
  }
}

class ChatBar extends StatefulWidget {
  final Function(String text, String? imagePath) onAddPost;

  const ChatBar({Key? key, required this.onAddPost}) : super(key: key);

  @override
  _ChatBarState createState() => _ChatBarState();
}

class _ChatBarState extends State<ChatBar> {
  final TextEditingController _textController = TextEditingController();
  File? _selectedImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _takePhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _sendPost() {
    if (_textController.text.isNotEmpty || _selectedImage != null) {
      widget.onAddPost(_textController.text, _selectedImage?.path);
      setState(() {
        _textController.clear();
        _selectedImage = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter text or select an image!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_selectedImage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Image.file(
                _selectedImage!,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.photo, color: Colors.blue),
                onPressed: _pickImage,
              ),
              IconButton(
                icon: const Icon(Icons.camera_alt, color: Colors.blue),
                onPressed: _takePhoto,
              ),
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: 'Write something spiritual...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.blue),
                onPressed: _sendPost,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
