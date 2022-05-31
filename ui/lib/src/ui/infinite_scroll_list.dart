// import 'package:ds_utils/ds_utils.dart';
// import 'package:flutter/material.dart';

// import '../../ds_ui.dart';

// class InfiniteScrollList<T extends Identifiable> extends StatefulWidget {
//   InfiniteScrollList({
//     this.listKey,
//     required this.model,
//     required this.itemBuilder,
//     this.separatorBuilder,
//     this.errorBuilder,
//     this.emptyBuilder,
//     this.onRefresh,
//     this.onLoadMore,
//     this.scrollController,
//     this.refreshColor,
//     this.refreshBackgroundColor,
//     this.brightness = Brightness.light,
//     this.overlays,
//     this.padding,
//     this.extraItemCount,
//   }) : key = listKey != null ? PageStorageKey(listKey) : null;
//   final ScrollController? scrollController;
//   final ListNetworkingModel<T> model;
//   final Color? refreshColor, refreshBackgroundColor;
//   final String? listKey;
//   final RefreshCallback? onRefresh, onLoadMore;
//   final IndexedWidgetBuilder itemBuilder;
//   final IndexedWidgetBuilder? separatorBuilder;
//   final WidgetBuilder? errorBuilder, emptyBuilder;
//   final Brightness brightness;
//   final List<Widget>? overlays;
//   final EdgeInsetsGeometry? padding;
//   final int? extraItemCount;

//   @override
//   final PageStorageKey? key;

//   int get extraItemsNeeded {
//     int _count = extraItemCount ?? 0;
//     if (model.hasData && loadMoreEnabled) {
//       _count++;
//     } else if ((model.hasError && errorBuilder != null) ||
//         (!model.hasData && emptyBuilder != null)) {
//       _count++;
//     }

//     return _count;
//   }

//   bool get loadMoreEnabled => onLoadMore != null && (model.canLoadMore != null);

//   int get calculatedItemCount => model.itemCount + extraItemsNeeded;

//   bool get hasDataOrIsLoading => model.hasData || (model.isInProgress);

//   RefreshIndicator refreshableList() => RefreshIndicator(
//         backgroundColor: refreshBackgroundColor,
//         color: refreshColor,
//         onRefresh: onRefresh!,
//         child: listView(scrollController),
//       );

//   ScrollPhysics get scrollPhysics => const AlwaysScrollableScrollPhysics();

//   Widget listView(ScrollController? controller) {
//     if (separatorBuilder == null) {
//       return ListView.builder(
//         key: key,
//         controller: controller,
//         physics: scrollPhysics,
//         itemCount: calculatedItemCount,
//         padding: padding,
//         itemBuilder:
//             hasDataOrIsLoading ? hasDataOrLoadingBuilder : emptyOrErrorBuilder,
//       );
//     } else {
//       return ListView.separated(
//         key: key,
//         controller: controller,
//         physics: scrollPhysics,
//         itemCount: calculatedItemCount,
//         padding: padding,
//         separatorBuilder: separatorBuilder ?? (_, __) => SizedBox(),
//         itemBuilder:
//             hasDataOrIsLoading ? hasDataOrLoadingBuilder : emptyOrErrorBuilder,
//       );
//     }
//   }

//   Widget hasDataOrLoadingBuilder(BuildContext context, int position) {
//     if (loadMoreEnabled && position == (calculatedItemCount - 1)) {
//       // Scroll more loader
//       if (model.canLoadMore) {
//         return Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: PlatformLoader(
//             centered: true,
//             brightness: brightness,
//           ),
//         );
//       } else {
//         return SizedBox();
//       }
//     } else if (!model.hasData) {
//       return SizedBox();
//     } else {
//       return itemBuilder(context, position);
//     }
//   }

//   Widget emptyOrErrorBuilder(BuildContext context, int position) {
//     if (position == calculatedItemCount - 1) {
//       // Scroll more loader
//       if (model.hasError && errorBuilder != null) {
//         return errorBuilder!(context);
//       } else if (!model.hasData && emptyBuilder != null) {
//         return emptyBuilder!(context);
//       } else {
//         return SizedBox();
//       }
//     } else {
//       return itemBuilder(context, position);
//     }
//   }

//   @override
//   _InfinteScrollListState createState() => _InfinteScrollListState();
// }

// class _InfinteScrollListState extends State<InfiniteScrollList> {
//   @override
//   void initState() {
//     super.initState();
//     if (widget.scrollController != null && widget.loadMoreEnabled)
//       widget.scrollController!.addListener(_scrollListener);
//   }

//   void _scrollListener() {
//     if (widget.scrollController == null || widget.onLoadMore == null) {
//       return;
//     }
//     if (widget.scrollController!.position.pixels ==
//             widget.scrollController!.position.maxScrollExtent &&
//         widget.model.shouldLoadMore) {
//       print('LOAD MORE');
//       widget.onLoadMore!();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return LoadingWrapper(
//       loading: widget.model.isInProgress,
//       loaderBrightness: widget.brightness,
//       children: <Widget>[
//         if (widget.onRefresh != null)
//           widget.refreshableList()
//         else
//           widget.listView(widget.scrollController),
//         ...(widget.overlays ?? []),
//       ],
//     );
//   }
// }
