import 'package:build_context/build_context.dart';
import 'package:flutter/cupertino.dart'
    show CupertinoSliverRefreshControl, RefreshControlIndicatorBuilder;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../dropsource_utils.dart';

final ScrollPhysics alwaysBouncingScrollPhysics =
    BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());

class ScrollableAppBar extends SliverAppBar {
  ScrollableAppBar({
    Widget title,
    bool floating = true,
    bool snap = true,
    bool stretch = false,
    double appBarElevation,
    Color backgroundColor,
    AsyncCallback onStretchTrigger,
    double expandedHeight,
    double collapsedHeight,
    bool automaticallyImplyLeading = false,
  }) : super(
          automaticallyImplyLeading: automaticallyImplyLeading,
          floating: floating,
          snap: snap,
          stretch: stretch,
          backgroundColor: backgroundColor ?? Colors.transparent,
          leading: null,
          title: title,
          actions: [
            SizedBox()
          ], // Used to hide the Scaffold.endDrawer specified in home_page.dart
          elevation: appBarElevation,
          onStretchTrigger: onStretchTrigger,
          expandedHeight: expandedHeight,
          collapsedHeight: collapsedHeight,
        );
}

class ScrollableLayout<T extends Identifiable> extends StatefulWidget {
  ScrollableLayout({
    String scrollKey,
    @required this.model,
    this.appBarExpandedHeight = 0,
    this.appBarCollapsedHeight,
    this.appBarColor,
    this.appBarHiddenUntilScroll = true,
    this.appBarBottom,
    this.appBarTitleSpacing,
    this.scrollingAppBarTitle,
    this.backButton,
    this.scrollingHeader,
    this.onRefresh,
    this.onLoadMore,
    this.itemBuilder,
    WidgetBuilder loadMoreBuilder,
    // this.refreshControlBuilder,
    this.separatorBuilder,
    this.errorBuilder,
    this.emptyBuilder,
    this.beforeSlivers,
    this.sliver,
    this.afterSlivers,
    this.overlays,
    this.appBarActions,
    this.bodyPadding,
    this.pinned,
    this.stretch,
    this.snap,
    this.centerAppBarTitle = true,
    this.automaticallyImplyLeading = true,
    this.floating,
    this.appBarElevation,
    this.scrollController,
    this.shrinkWrap = false,
    this.scrollPhysics =
        const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
  })  : key = scrollKey != null ? PageStorageKey(scrollKey) : null,
        loadMoreBuilder = loadMoreBuilder ??
            ((_) => SliverToBoxAdapter(child: PlatformLoader(centered: true)));
  // refreshControlBuilder = refreshControlBuilder;
  // CupertinoSliverRefreshControl.buildRefreshIndicator(context, refreshState, pulledExtent, refreshTriggerPullDistance, refreshIndicatorExtent);

  @override
  final PageStorageKey key;
  final ListNetworkingModel<T> model;
  final RefreshCallback onRefresh, onLoadMore;
  final IndexedWidgetBuilder itemBuilder, separatorBuilder;
  final WidgetBuilder errorBuilder, emptyBuilder, loadMoreBuilder;
  // final RefreshControlIndicatorBuilder refreshControlBuilder;

  final Color appBarColor;
  final Widget scrollingAppBarTitle;
  final Widget backButton;
  final Widget scrollingHeader;
  final double appBarExpandedHeight, appBarCollapsedHeight, appBarTitleSpacing;
  final PreferredSizeWidget appBarBottom;
  final List<Widget> beforeSlivers, afterSlivers, overlays;
  final Widget sliver;
  final EdgeInsetsGeometry bodyPadding;
  final bool pinned, stretch, snap, floating;
  final bool shrinkWrap, centerAppBarTitle;
  final bool appBarHiddenUntilScroll, automaticallyImplyLeading;
  final double appBarElevation;
  final List<Widget> appBarActions;
  final ScrollController scrollController;
  final ScrollPhysics scrollPhysics;

  bool get loadMoreEnabled =>
      (model.shouldLoadMore != null) &&
      onLoadMore != null &&
      (model.canLoadMore != null);

  bool get hasDataOrIsLoading => model.hasData || isLoading;

  bool get isLoading => model.isInProgress ?? false;

  @override
  _ScrollableLayoutState createState() => _ScrollableLayoutState();
}

class _ScrollableLayoutState extends State<ScrollableLayout> {
  ScrollController _controller;
  bool _isScrolled = false;

  bool get _requiresScrollListener =>
      _hasFlexibleSpace && widget.appBarHiddenUntilScroll;

  bool get _hasFlexibleSpace =>
      widget.scrollingHeader != null && widget.appBarExpandedHeight != null;

  @override
  void initState() {
    super.initState();
    _controller = widget.scrollController ?? ScrollController();
    if (_requiresScrollListener) {
      _controller.addListener(_listenToScrollChange);
    }

    if (widget.loadMoreEnabled) {
      _controller.addListener(_scrollListener);
    }
  }

  void _scrollListener() {
    if (widget.scrollController.position.pixels ==
            widget.scrollController.position.maxScrollExtent &&
        widget.model.shouldLoadMore) {
      print('LOAD MORE');
      widget.onLoadMore();
    }
  }

  void _listenToScrollChange() {
    // TODO: need a better way of doing this so I don't have to lookup context over scroll
    final offset = MediaQuery.of(context, nullOk: true)?.padding?.top ?? 0;
    if (_controller.offset >= widget.appBarExpandedHeight - offset && mounted) {
      setState(() {
        _isScrolled = true;
      });
    } else if (_isScrolled && mounted) {
      setState(() {
        _isScrolled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingWrapper(
      loading: widget.isLoading,
      ignorePointerWhenLoading: false,
      children: [
        CustomScrollView(
          key: widget.key,
          controller: _controller,
          physics: widget.scrollPhysics,
          shrinkWrap: widget.shrinkWrap,
          slivers: [
            SliverAppBar(
              backgroundColor: widget.appBarColor,
              automaticallyImplyLeading:
                  widget.automaticallyImplyLeading ?? true,
              titleSpacing:
                  widget.appBarTitleSpacing ?? NavigationToolbar.kMiddleSpacing,
              title: _requiresScrollListener
                  ? AnimatedOpacity(
                      duration: Duration(milliseconds: 300),
                      opacity: _isScrolled ? 1.0 : 0.0,
                      curve: Curves.easeIn,
                      child: widget.scrollingAppBarTitle,
                    )
                  : widget.scrollingAppBarTitle,
              leading: widget.backButton,
              actions: widget.appBarActions,
              centerTitle: widget.centerAppBarTitle ?? true,
              pinned: widget.pinned ?? false,
              stretch: widget.stretch ?? false,
              floating: widget.floating ?? false,
              elevation: widget.appBarElevation,
              snap: widget.snap ?? false,
              expandedHeight: widget.appBarExpandedHeight,
              collapsedHeight: widget.appBarCollapsedHeight,
              primary: true,
              bottom: widget.appBarBottom,
              flexibleSpace: _hasFlexibleSpace
                  ? FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      background: widget.scrollingHeader,
                    )
                  : null,
            ),
            ...refreshBuilder,
            ...(widget.beforeSlivers ?? []),
            ...errorBuilder,
            ...emptyBuilder,
            ...hasDataOrLoadingBuilder,
            ...loadMoreBuilder,
            ...(widget.afterSlivers ?? []),
          ],
        ),
        ...(widget.overlays ?? [])
      ],
    );
  }

  List<Widget> get refreshBuilder => [
        if (widget.onRefresh != null)
          CupertinoSliverRefreshControl(
            onRefresh: widget.onRefresh,
            // builder: widget.refreshControlBuilder,
          ),
      ];

  List<Widget> get hasDataOrLoadingBuilder => [
        if (widget.hasDataOrIsLoading && widget.sliver != null)
          SliverPadding(
            sliver: widget.sliver,
            padding: widget.bodyPadding ?? EdgeInsets.all(0),
          ),
      ];

  List<Widget> get loadMoreBuilder => [
        if (widget.model.isLoadingMore)
          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: widget.loadMoreBuilder(context),
          ),
      ];

  List<Widget> get emptyBuilder => [
        if (widget.emptyBuilder != null &&
            !widget.model.hasError &&
            !widget.model.hasData &&
            !widget.isLoading)
          widget.emptyBuilder(context),
      ];

  List<Widget> get errorBuilder => [
        if (widget.errorBuilder != null && widget.model.hasError)
          widget.errorBuilder(context),
      ];
}

// This widget is used in cases where you have a banner image or background that you want
// to be able to scroll up to hide it and down to expand it. For an example, see `module_detail_page.dart`
class ScrollableHeaderFixedChildrenLayout extends ScrollableLayout {
  ScrollableHeaderFixedChildrenLayout({
    @required double appBarExpandedHeight,
    Color appBarColor,
    Widget scrollingAppBarTitle,
    Widget backButton,
    Widget scrollingHeader,
    List<Widget> bodyChildren,
    List<Widget> appBarActions,
    EdgeInsetsGeometry bodyPadding,
    double appBarElevation,
  }) : super(
          appBarExpandedHeight: appBarExpandedHeight,
          appBarColor: appBarColor,
          scrollingAppBarTitle: scrollingAppBarTitle,
          backButton: backButton,
          scrollingHeader: scrollingHeader,
          sliver:
              SliverList(delegate: SliverChildListDelegate.fixed(bodyChildren)),
          appBarActions: appBarActions,
          bodyPadding: bodyPadding,
          appBarElevation: appBarElevation,
          stretch: true,
          pinned: true,
          snap: false,
        );
}

class ScrollableHeaderBuilderLayout extends ScrollableLayout {
  ScrollableHeaderBuilderLayout({
    @required double appBarExpandedHeight,
    Color appBarColor,
    Widget scrollingAppBarTitle,
    Widget backButton,
    Widget scrollingHeader,
    IndexedWidgetBuilder builder,
    int itemCount,
    List<Widget> appBarActions,
    EdgeInsetsGeometry bodyPadding,
    double appBarElevation,
  }) : super(
          appBarExpandedHeight: appBarExpandedHeight,
          appBarColor: appBarColor,
          scrollingAppBarTitle: scrollingAppBarTitle,
          backButton: backButton,
          scrollingHeader: scrollingHeader,
          sliver: SliverList(
              delegate:
                  SliverChildBuilderDelegate(builder, childCount: itemCount)),
          appBarActions: appBarActions,
          bodyPadding: bodyPadding,
          appBarElevation: appBarElevation,
          stretch: true,
          pinned: true,
          snap: false,
        );
}

class DSScrollToHideAppBarLayout extends ScrollableLayout {
  DSScrollToHideAppBarLayout({
    Color appBarColor,
    Widget scrollingAppBarTitle,
    Widget backButton,
    List<Widget> bodyChildren,
    List<Widget> appBarActions,
    EdgeInsetsGeometry bodyPadding,
    double appBarElevation,
    bool pinAppBar = true,
    bool stretchAppBar = true,
    bool snapAppBar = false,
    bool floatingAppBar = false,
  }) : super(
          appBarExpandedHeight: null,
          appBarColor: appBarColor,
          scrollingAppBarTitle: scrollingAppBarTitle,
          backButton: backButton,
          scrollingHeader: null,
          sliver:
              SliverList(delegate: SliverChildListDelegate.fixed(bodyChildren)),
          appBarActions: appBarActions,
          appBarElevation: appBarElevation,
          bodyPadding: bodyPadding,
          stretch: stretchAppBar,
          pinned: pinAppBar,
          snap: snapAppBar,
          floating: floatingAppBar,
        );
}
