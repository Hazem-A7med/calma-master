import 'package:flutter/material.dart';

class PostItem extends StatefulWidget {
  const PostItem(
      {Key? key, this.name, this.image, this.mediaType, this.mediaLink, this.description})
      : super(key: key);
  final String? name;
  final String? image;
  final String? mediaType;
  final String? mediaLink;
  final String? description;

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white38.withOpacity(.15),
            borderRadius: BorderRadius.circular(7)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.more_horiz,
                  color: Colors.white.withOpacity(.7),
                  size: 20,
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          widget.name ?? '',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white),
                        ),
                        Row(
                          children: [
                            Image.asset(
                              'assets/icons/all.png',
                              width: 10,
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            Text(
                              '22 دقيقة',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white.withOpacity(.4)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(
                          widget.image ?? ''),
                    ),
                  ],
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Text(
                  widget.description ?? '',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
            ),
            (widget.mediaType == 'photo') ? Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Image.network(
                widget.mediaLink ?? '',
                width: double.infinity,
                fit: BoxFit.fitWidth,),
            ):const SizedBox(),
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.white38.withOpacity(.3),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 8.0, left: 10, right: 10, top: 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('مشاركة',
                          style: TextStyle(
                              color: Colors.white.withOpacity(.3),
                              fontSize:
                              MediaQuery
                                  .of(context)
                                  .size
                                  .width * .023)),
                      const SizedBox(
                        width: 7,
                      ),
                      Image.asset('assets/icons/share.png', height: 12),
                    ],
                  ),
                  Row(
                    children: [
                      Text('تقييم',
                          style: TextStyle(
                              color: Colors.white.withOpacity(.3),
                              fontSize:
                              MediaQuery
                                  .of(context)
                                  .size
                                  .width * .023)),
                      const SizedBox(
                        width: 7,
                      ),
                      Image.asset('assets/icons/rate.png', height: 12),
                    ],
                  ),
                  Row(
                    children: [
                      Text('التعليقات',
                          style: TextStyle(
                              color: Colors.white.withOpacity(.3),
                              fontSize:
                              MediaQuery
                                  .of(context)
                                  .size
                                  .width * .023)),
                      const SizedBox(
                        width: 7,
                      ),
                      Image.asset('assets/icons/comment.png', height: 12),
                    ],
                  ),
                  Row(
                    children: [
                      Text('أعجبني',
                          style: TextStyle(
                              color: Colors.white.withOpacity(.3),
                              fontSize:
                              MediaQuery
                                  .of(context)
                                  .size
                                  .width * .023)),
                      const SizedBox(
                        width: 7,
                      ),
                      Image.asset('assets/icons/like.png', height: 12),
                    ],
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
