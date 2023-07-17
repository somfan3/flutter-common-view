import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_common_view/src/platform_indicator.dart';

class ListViewBuilderPagination extends StatelessWidget {
  final int itemCount;
  final IndexedWidgetBuilder? separatorBuilder;
  final NullableIndexedWidgetBuilder itemBuilder;
  final ScrollController? controller;
  final bool? primary;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final EdgeInsets? padding;
  final bool isLastPage;
  final Function()? onLoadMore;
  final Future Function()? onRefresh;

  const ListViewBuilderPagination({
    Key? key,
    required this.itemCount,
    this.separatorBuilder,
    required this.itemBuilder,
    this.primary,
    this.controller,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.isLastPage = true,
    this.onLoadMore,
    this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollEndNotification>(
      onNotification: (scrollNotification) {
        if (isLastPage) {
          return true;
        }

        if (scrollNotification.metrics.pixels ==
            scrollNotification.metrics.maxScrollExtent) {
          if (onLoadMore != null) {
            onLoadMore!();
          }
        }

        return true;
      },
      child: onRefresh != null
          ? RefreshIndicator(
              onRefresh: onRefresh!,
              // keyRefresh: keyRefresh,
              child: _buildListView(),
            )
          : _buildListView(),
    );
  }

  _buildListView() {
    final int count = onLoadMore != null ? itemCount + 1 : itemCount;

    return ListView.separated(
      controller: controller,
      padding: padding,
      physics: physics,
      shrinkWrap: Platform.isIOS ? true : shrinkWrap,
      primary: Platform.isIOS ? false : primary,
      // controller: controller,
      itemCount: count,
      separatorBuilder:
          separatorBuilder ?? (context, index) => const SizedBox(height: 8),
      itemBuilder: _itemBuilder,
    );
  }

  Widget? _itemBuilder(BuildContext context, int index) {
    if (onLoadMore != null && index == itemCount) {
      return !isLastPage ? const PlatformIndicator() : const SizedBox();
    }
    return itemBuilder(context, index);
  }
}
