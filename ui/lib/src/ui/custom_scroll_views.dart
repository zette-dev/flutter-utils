import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../zette_ui.dart';

final ScrollPhysics alwaysBouncingScrollPhysics = BouncingScrollPhysics(
  parent: AlwaysScrollableScrollPhysics(),
);

class ScrollableAppBar extends SliverAppBar {
  ScrollableAppBar({
    super.title,
    super.floating = true,
    super.snap = true,
    super.stretch = false,
    super.elevation,
    super.scrolledUnderElevation,
    super.backgroundColor,
    super.onStretchTrigger,
    super.expandedHeight,
    super.collapsedHeight,
    super.automaticallyImplyLeading = false,
  }) : super(
         leading: null,
         actions: [
           SizedBox(),
         ], // Used to hide the Scaffold.endDrawer specified in home_page.dart
       );
}

class ScrollableAppBarBehavior {
  const ScrollableAppBarBehavior({
    this.expandedHeight = 0,
    this.collapsedHeight,
    this.color,
    this.hiddenUntilScroll = true,
    this.bottom,
    this.titleSpacing = NavigationToolbar.kMiddleSpacing,
    this.title,
    this.backButton,
    this.leadingWidth,
    this.flexibleBackground,
    this.actions,
    this.pinned = false,
    this.stretch = false,
    this.snap = false,
    this.floating = false,
    this.appBarElevation,
    this.scrolledUnderElevation,
    this.flexibleTitle,
    this.centerFlexibleTitle,
    this.toolbarHeight = kToolbarHeight,
    this.flexibleCollapseMode = CollapseMode.pin,
    this.centerTitle = true,
    this.automaticallyImplyLeading = true,
    this.statusBarBrightness,
  });

  final Color? color;
  final Widget? title;
  final Widget? backButton;
  final Widget? flexibleBackground, flexibleTitle;
  final bool? centerFlexibleTitle;
  final double? expandedHeight, collapsedHeight, leadingWidth;
  final double titleSpacing;
  final PreferredSizeWidget? bottom;
  final bool pinned, stretch, snap, floating;
  final double? appBarElevation, scrolledUnderElevation;
  final List<Widget>? actions;
  final CollapseMode flexibleCollapseMode;
  final double toolbarHeight;
  final bool hiddenUntilScroll;
  final bool centerTitle, automaticallyImplyLeading;
  final Brightness? statusBarBrightness;
}

class ScrollLayout extends StatefulWidget {
  ScrollLayout({
    String? scrollKey,
    // AppBar
    this.appBarBehavior = const ScrollableAppBarBehavior(),
    // Loaders
    this.onRefresh,
    this.onLoadMore,

    // Builders
    WidgetBuilder? loadMoreBuilder,
    this.errorBuilder,
    this.emptyBuilder,
    this.beforeSlivers,
    this.sliver,
    this.afterSlivers,
    this.beforeAppBar,
    this.overlays,
    this.bodyPadding,
    this.scrollController,
    this.refreshColor,

    // List
    this.shrinkWrap = false,
    this.shouldLoadMore,
    this.canLoadMore,
    this.isLoading,
    this.hasData,
    this.hasError,
    this.isLoadingMore,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.onDrag,
    this.scrollPhysics = const BouncingScrollPhysics(
      parent: AlwaysScrollableScrollPhysics(),
    ),
  }) : key = scrollKey != null ? PageStorageKey(scrollKey) : null,
       loadMoreBuilder =
           loadMoreBuilder ??
           ((_) => SliverToBoxAdapter(child: PlatformLoader(centered: true)));

  final ScrollableAppBarBehavior? appBarBehavior;

  @override
  final PageStorageKey? key;
  final RefreshCallback? onRefresh, onLoadMore;
  final WidgetBuilder? errorBuilder, emptyBuilder, loadMoreBuilder;
  final Color? refreshColor;

  final List<Widget>? beforeSlivers, afterSlivers, overlays, beforeAppBar;
  final Widget? sliver;
  final EdgeInsetsGeometry? bodyPadding;
  final bool? shrinkWrap;

  final ScrollController? scrollController;
  final ScrollPhysics? scrollPhysics;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  final bool Function()? shouldLoadMore,
      canLoadMore,
      isLoadingMore,
      isLoading,
      hasData,
      hasError;

  factory ScrollLayout.fixedList({
    ScrollableAppBarBehavior? appBarBehavior,
    Color? refreshColor,
    RefreshCallback? onRefresh,
    WidgetBuilder? errorBuilder,
    WidgetBuilder? emptyBuilder,
    WidgetBuilder? loadMoreBuilder,
    List<Widget>? beforeSlivers,
    List<Widget>? afterSlivers,
    List<Widget>? overlays,
    List<Widget>? beforeAppBar,
    EdgeInsetsGeometry? bodyPadding,
    bool? shrinkWrap,
    ScrollController? scrollController,
    ScrollPhysics? scrollPhysics,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    bool Function()? isLoading,
    bool Function()? hasData,
    bool Function()? hasError,
    required List<Widget> children,
  }) => ScrollLayout(
    appBarBehavior: appBarBehavior,
    refreshColor: refreshColor,
    onRefresh: onRefresh,
    onLoadMore: null, // fixed lists won't load more
    shouldLoadMore: null,
    canLoadMore: null,
    errorBuilder: errorBuilder,
    emptyBuilder: emptyBuilder,
    loadMoreBuilder: loadMoreBuilder,
    beforeSlivers: beforeSlivers,
    afterSlivers: afterSlivers,
    beforeAppBar: beforeAppBar,
    overlays: overlays,
    keyboardDismissBehavior: keyboardDismissBehavior,
    bodyPadding: bodyPadding,
    shrinkWrap: shrinkWrap,
    scrollController: scrollController,
    scrollPhysics: scrollPhysics,
    isLoading: isLoading,
    hasData: hasData,
    hasError: hasError,
    sliver: SliverList(delegate: SliverChildListDelegate.fixed(children)),
  );

  factory ScrollLayout.dynamicList({
    ScrollableAppBarBehavior? appBarBehavior,
    Color? refreshColor,
    RefreshCallback? onRefresh,
    WidgetBuilder? errorBuilder,
    WidgetBuilder? emptyBuilder,
    WidgetBuilder? loadMoreBuilder,
    List<Widget>? beforeSlivers,
    List<Widget>? afterSlivers,
    List<Widget>? overlays,
    EdgeInsetsGeometry? bodyPadding,
    bool? shrinkWrap,
    ScrollController? scrollController,
    ScrollPhysics? scrollPhysics,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    bool Function()? isLoading,
    bool Function()? hasData,
    bool Function()? hasError,
    required IndexedWidgetBuilder builder,
    required int itemCount,
  }) => ScrollLayout(
    appBarBehavior: appBarBehavior,
    refreshColor: refreshColor,
    onRefresh: onRefresh,
    onLoadMore: null, // fixed lists won't load more
    shouldLoadMore: null,
    canLoadMore: null,
    errorBuilder: errorBuilder,
    emptyBuilder: emptyBuilder,
    loadMoreBuilder: loadMoreBuilder,
    beforeSlivers: beforeSlivers,
    afterSlivers: afterSlivers,
    overlays: overlays,
    keyboardDismissBehavior: keyboardDismissBehavior,
    bodyPadding: bodyPadding,
    shrinkWrap: shrinkWrap,
    scrollController: scrollController,
    scrollPhysics: scrollPhysics,
    isLoading: isLoading,
    hasData: hasData,
    hasError: hasError,
    sliver: SliverList(
      delegate: SliverChildBuilderDelegate(builder, childCount: itemCount),
    ),
  );

  factory ScrollLayout.dynamicGrid({
    ScrollableAppBarBehavior? appBarBehavior,
    Color? refreshColor,
    RefreshCallback? onRefresh,
    WidgetBuilder? errorBuilder,
    WidgetBuilder? emptyBuilder,
    WidgetBuilder? loadMoreBuilder,
    List<Widget>? beforeSlivers,
    List<Widget>? afterSlivers,
    List<Widget>? overlays,
    EdgeInsetsGeometry? bodyPadding,
    bool? shrinkWrap,
    ScrollController? scrollController,
    ScrollPhysics? scrollPhysics,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    bool Function()? isLoading,
    bool Function()? hasData,
    bool Function()? hasError,
    required IndexedWidgetBuilder builder,
    required int itemCount,
    int crossAxisCount = 2,
    double childAspectRatio = 1.5,
    double mainAxisSpacing = 5.0,
    double crossAxisSpacing = 5.0,
  }) => ScrollLayout(
    refreshColor: refreshColor,
    appBarBehavior: appBarBehavior,
    onRefresh: onRefresh,
    onLoadMore: null, // fixed lists won't load more
    shouldLoadMore: null,
    canLoadMore: null,
    errorBuilder: errorBuilder,
    emptyBuilder: emptyBuilder,
    loadMoreBuilder: loadMoreBuilder,
    beforeSlivers: beforeSlivers,
    afterSlivers: afterSlivers,
    overlays: overlays,
    keyboardDismissBehavior: keyboardDismissBehavior,
    bodyPadding: bodyPadding,
    shrinkWrap: shrinkWrap,
    scrollController: scrollController,
    scrollPhysics: scrollPhysics,
    isLoading: isLoading,
    hasData: hasData,
    hasError: hasError,
    sliver: SliverGrid(
      delegate: SliverChildBuilderDelegate(builder, childCount: itemCount),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
      ),
    ),
  );

  factory ScrollLayout.infiniteList({
    ScrollableAppBarBehavior? appBarBehavior,
    RefreshCallback? onRefresh,
    WidgetBuilder? errorBuilder,
    WidgetBuilder? emptyBuilder,
    WidgetBuilder? loadMoreBuilder,
    List<Widget>? beforeSlivers,
    List<Widget>? overlays,
    EdgeInsetsGeometry? bodyPadding,
    bool? shrinkWrap,
    ScrollController? scrollController,
    ScrollPhysics? scrollPhysics,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    bool Function()? isLoading,
    bool Function()? hasData,
    bool Function()? hasError,
    required bool Function() shouldLoadMore,
    required bool Function() canLoadMore,
    required RefreshCallback onLoadMore,
    required IndexedWidgetBuilder builder,
    required int itemCount,
  }) => ScrollLayout(
    appBarBehavior: appBarBehavior,
    onRefresh: onRefresh,
    onLoadMore: onLoadMore,
    shouldLoadMore: shouldLoadMore,
    canLoadMore: canLoadMore,
    errorBuilder: errorBuilder,
    emptyBuilder: emptyBuilder,
    loadMoreBuilder: loadMoreBuilder,
    beforeSlivers: beforeSlivers,
    afterSlivers: null,
    overlays: overlays,
    keyboardDismissBehavior: keyboardDismissBehavior,
    bodyPadding: bodyPadding,
    shrinkWrap: shrinkWrap,
    scrollController: scrollController,
    scrollPhysics: scrollPhysics,
    isLoading: isLoading,
    hasData: hasData,
    hasError: hasError,
    sliver: SliverList(
      delegate: SliverChildBuilderDelegate(builder, childCount: itemCount),
    ),
  );

  @override
  _ScrollLayoutState createState() => _ScrollLayoutState();
}

class _ScrollLayoutState extends State<ScrollLayout> {
  /// Scrolling
  ScrollController? _controller;
  bool _isScrolled = false;
  bool get _requiresScrollListener =>
      _hasFlexibleSpace && (widget.appBarBehavior?.hiddenUntilScroll ?? false);

  /// Loading More
  bool get shouldLoadMore => widget.shouldLoadMore?.call() ?? false;
  bool get isLoadingMore => widget.isLoadingMore?.call() ?? false;
  bool get loadMoreEnabled =>
      (widget.shouldLoadMore != null) &&
      widget.onLoadMore != null &&
      (widget.canLoadMore != null);

  /// Display
  bool get isLoading => widget.isLoading?.call() ?? false;
  bool get hasData => widget.hasData?.call() ?? false;
  bool get hasError => widget.hasError?.call() ?? false;

  bool get hasDataOrIsLoading => hasData || isLoading;

  bool get _hasFlexibleSpace =>
      widget.appBarBehavior?.flexibleBackground != null &&
      widget.appBarBehavior?.expandedHeight != null;

  @override
  void initState() {
    super.initState();
    _controller = widget.scrollController ?? ScrollController();

    if (_requiresScrollListener) {
      _controller?.addListener(_listenToScrollChange);
    }
    if (loadMoreEnabled) {
      _controller?.addListener(_scrollListener);
    }
  }

  @override
  void dispose() {
    if (_requiresScrollListener) {
      _controller?.removeListener(_listenToScrollChange);
    }
    if (loadMoreEnabled) {
      _controller?.removeListener(_scrollListener);
    }
    // Only dispose controller if we created it
    if (widget.scrollController == null) {
      _controller?.dispose();
    }
    super.dispose();
  }

  void _scrollListener() {
    final position = _controller?.position;
    if (position != null &&
        position.pixels == position.maxScrollExtent &&
        shouldLoadMore &&
        widget.onLoadMore != null) {
      widget.onLoadMore!();
    }
  }

  /// Tracks scroll position to control app bar title visibility.
  /// Uses cached padding value to avoid repeated MediaQuery lookups.
  double? _cachedTopPadding;

  Widget _buildAppBar() {
    final behavior = widget.appBarBehavior!;
    final title = _requiresScrollListener
        ? AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: _isScrolled ? 1.0 : 0.0,
            curve: Curves.easeIn,
            child: behavior.title,
          )
        : behavior.title;

    return SliverAppBar(
      backgroundColor: behavior.color,
      toolbarHeight: behavior.toolbarHeight,
      automaticallyImplyLeading: behavior.automaticallyImplyLeading,
      titleSpacing: behavior.titleSpacing,
      scrolledUnderElevation: behavior.scrolledUnderElevation,
      title: title,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: behavior.statusBarBrightness,
      ),
      leading: behavior.backButton,
      leadingWidth: behavior.leadingWidth,
      actions: behavior.actions,
      centerTitle: behavior.centerTitle,
      pinned: behavior.pinned,
      stretch: behavior.stretch,
      floating: behavior.floating,
      elevation: behavior.appBarElevation,
      snap: behavior.snap,
      expandedHeight: behavior.expandedHeight,
      collapsedHeight: behavior.collapsedHeight,
      primary: true,
      bottom: behavior.bottom,
      flexibleSpace: _hasFlexibleSpace
          ? FlexibleSpaceBar(
              collapseMode: behavior.flexibleCollapseMode,
              background: behavior.flexibleBackground,
              title: behavior.flexibleTitle,
              centerTitle: behavior.centerFlexibleTitle,
            )
          : null,
    );
  }

  void _listenToScrollChange() {
    if (!mounted) return;

    _cachedTopPadding ??= MediaQuery.of(context).padding.top;
    final threshold =
        (widget.appBarBehavior?.expandedHeight ?? 0) - _cachedTopPadding!;
    final isNowScrolled = (_controller?.offset ?? 0) >= threshold;

    if (isNowScrolled != _isScrolled) {
      safeSetState(() {
        _isScrolled = isNowScrolled;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingWrapper(
      loading: isLoading,
      ignorePointerWhenLoading: false,
      loaderColor: widget.refreshColor,
      children: [
        CustomScrollView(
          key: widget.key,
          controller: _controller,
          physics: widget.scrollPhysics,
          shrinkWrap: widget.shrinkWrap ?? false,
          keyboardDismissBehavior: widget.keyboardDismissBehavior,
          slivers: [
            ...(widget.beforeAppBar ?? []),
            if (widget.appBarBehavior != null) _buildAppBar(),
            if (_refreshSliver != null) _refreshSliver!,
            ...(widget.beforeSlivers ?? []),
            if (_errorSliver != null) _errorSliver!,
            if (_emptySliver != null) _emptySliver!,
            if (_contentSliver != null) _contentSliver!,
            if (_loadMoreSliver != null) _loadMoreSliver!,
            ...(widget.afterSlivers ?? []),
          ],
        ),
        ...(widget.overlays ?? []),
      ],
    );
  }

  Widget? get _refreshSliver => widget.onRefresh != null
      ? PlatformSliverRefreshControl(
          onRefresh: widget.onRefresh,
          refreshColor: widget.refreshColor,
        )
      : null;

  Widget? get _contentSliver => hasDataOrIsLoading && widget.sliver != null
      ? SliverPadding(
          sliver: widget.sliver,
          padding: widget.bodyPadding ?? EdgeInsets.zero,
        )
      : null;

  Widget? get _loadMoreSliver => isLoadingMore && widget.loadMoreBuilder != null
      ? SliverPadding(
          padding: const EdgeInsets.all(8.0),
          sliver: widget.loadMoreBuilder!(context),
        )
      : null;

  Widget? get _emptySliver =>
      widget.emptyBuilder != null && !hasError && !hasData && !isLoading
      ? widget.emptyBuilder!(context)
      : null;

  Widget? get _errorSliver => widget.errorBuilder != null && hasError
      ? widget.errorBuilder!(context)
      : null;
}
