import 'package:demo_app/style/style.dart';
import 'package:flutter/material.dart';

class Comments extends StatelessWidget {
  final String? comment;

  const Comments({Key? key,this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [

          DecoratedBox(
            decoration:  BoxDecoration(color: Colors.transparent),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(comment!,style: helveticaWBMediumWhite(context),),
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.all(Radius.circular(15.0))
      ),

    );
  }
}
