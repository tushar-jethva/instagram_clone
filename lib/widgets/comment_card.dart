// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:instagram_clone/Models/comment_model.dart';
import 'package:intl/intl.dart';

class MyCommentCard extends StatefulWidget {
  final CommentModel comment;
  const MyCommentCard({
    Key? key,
    required this.comment,
  }) : super(key: key);

  @override
  State<MyCommentCard> createState() => _MyCommentCardState();
}

class _MyCommentCardState extends State<MyCommentCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ListTile(
        leading: CircleAvatar(
          radius: 20,
          foregroundImage: CachedNetworkImageProvider(widget.comment.userPhoto),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.comment.username),
            Gap(20),
            Expanded(
                child: Text(
              widget.comment.comment,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            )),
            Gap(20),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            DateFormat.yMMMd().format(widget.comment.datePublished.toDate()),
          ),
        ),
      ),
    );
  }
}
