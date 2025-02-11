import 'package:flutter/material.dart';
import 'comments_page.dart'; // Import the CommentsPage

class SocialFeedScreen extends StatelessWidget {
  const SocialFeedScreen({Key? key}) : super(key: key);

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
            itemCount: 10, // Placeholder for posts count
            itemBuilder: (context, index) {
              return PostCard(
                username: 'User $index',
                profileImage: 'https://via.placeholder.com/50', // Placeholder image
                postText: 'This is post number $index.',
                postImage: index % 2 == 0
                    ? 'https://via.placeholder.com/300' // Placeholder image for posts
                    : null,
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ChatBar(), // Add the chat bar at the bottom
          ),
        ],
      ),
    );
  }
}

class PostCard extends StatefulWidget {
  final String username;
  final String profileImage;
  final String postText;
  final String? postImage;

  const PostCard({
    Key? key,
    required this.username,
    required this.profileImage,
    required this.postText,
    this.postImage,
  }) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CommentsPage(
              username: widget.username,
              postText: widget.postText,
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
              leading: CircleAvatar(
                backgroundImage: NetworkImage(widget.profileImage),
              ),
              title: Text(
                widget.username,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            if (widget.postImage != null)
              Image.network(
                widget.postImage!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(widget.postText),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isLiked = !isLiked;
                      });
                    },
                    child: Icon(
                      Icons.star,
                      color: isLiked ? Colors.yellow : Colors.grey,
                      size: 24,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.comment_outlined),
                    onPressed: () {
                      // Handle comments
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.share_outlined),
                    onPressed: () {
                      // Handle sharing
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatBar extends StatelessWidget {
  const ChatBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.photo, color: Colors.blue),
            onPressed: () {
              // Open photo gallery
            },
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt, color: Colors.blue),
            onPressed: () {
              // Open camera
            },
          ),
          Expanded(
            child: TextField(
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
            onPressed: () {
              // Handle sending post
            },
          ),
        ],
      ),
    );
  }
}
