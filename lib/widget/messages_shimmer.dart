import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'placeholders.dart';

class LoadingMessagesShimmerWidget extends StatefulWidget {
  const LoadingMessagesShimmerWidget({super.key});

  @override
  State<LoadingMessagesShimmerWidget> createState() =>
      _LoadingMessagesShimmerWidgetState();
}

class _LoadingMessagesShimmerWidgetState
    extends State<LoadingMessagesShimmerWidget> {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        enabled: true,
        child: const SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 16.0),
              ContentPlaceholder(
                lineType: ContentLineType.threeLines,
              ),
              SizedBox(height: 16.0),
              TitlePlaceholder(width: 200.0),
              SizedBox(height: 16.0),
              SizedBox(
                width: 200,
                child: ContentPlaceholder(
                  lineType: ContentLineType.twoLines,
                ),
              ),
              SizedBox(height: 16.0),
              SizedBox(height: 16.0),
              RightSideContentPlaceholder(
                lineType: ContentLineType.threeLines,
              ),
              SizedBox(height: 16.0),
              SizedBox(height: 16.0),
              TitlePlaceholder(width: 200.0),
              SizedBox(height: 16.0),
              SizedBox(height: 16.0),
              ContentPlaceholder(
                lineType: ContentLineType.twoLines,
              ),
              RightSideContentPlaceholder(
                lineType: ContentLineType.threeLines,
              ),
              SizedBox(height: 16.0),
              ContentPlaceholder(
                lineType: ContentLineType.twoLines,
              ),
              SizedBox(height: 16.0),
              SizedBox(height: 16.0),
              RightSideContentPlaceholder(
                lineType: ContentLineType.threeLines,
              ),
              SizedBox(height: 16.0),
              SizedBox(height: 16.0),
              TitlePlaceholder(width: 200.0),
              SizedBox(height: 16.0),
              SizedBox(height: 16.0),
              ContentPlaceholder(
                lineType: ContentLineType.twoLines,
              ),
              RightSideContentPlaceholder(
                lineType: ContentLineType.threeLines,
              ),
            ],
          ),
        ));
  }
}
