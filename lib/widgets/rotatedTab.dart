import 'package:flutter/material.dart';

class RotatedTabBar extends StatelessWidget {
  RotatedTabBar({Key key, this.tabs, this.tabController, this.quarterTurns = 0}) : super(key: key);
  final List<Widget> tabs;
  final TabController tabController;
  final int quarterTurns;

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: quarterTurns,
      child: FocusTraversalOrder(
        order: NumericFocusOrder(0),
        child: TabBar(
          isScrollable: true,
          labelPadding: EdgeInsets.zero,
          tabs: tabs,
          controller: tabController,
          indicatorColor: Colors.transparent,
        ),
      ),
    );
  }
}

class RotatedTab extends StatefulWidget {
  RotatedTab({
    IconData iconData,
    this.title,
    int tabIndex,
    this.tabCount,
    TabController tabController,
    this.quarterTurns = 0,
    this.leftOrTopPadding,
}) :  isExpanded = tabController.index == tabIndex,
        icon = Icon(iconData, semanticLabel: title),
        isVertical = quarterTurns % 2 == 1;

  final String title;
  final Icon icon;
  final int tabCount;
  final bool isExpanded;
  final int quarterTurns;
  final bool isVertical;
  final double leftOrTopPadding;

  @override
  _RotatedTabState createState() => _RotatedTabState();
}

class _RotatedTabState extends State<RotatedTab>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _titleSizeAnimation;
  Animation<double> _titleFadeAnimation;
  Animation<double> _iconFadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _titleSizeAnimation = _controller.view;
    _titleFadeAnimation = _controller.drive(CurveTween(curve: Curves.easeOut));
    _iconFadeAnimation = _controller.drive(Tween<double>(begin: 0.6, end: 1));
    if(widget.isExpanded) _controller.value = 1;
  }

  @override
  void didUpdateWidget(RotatedTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(widget.isExpanded) {
      _controller.forward();
    }
    else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    Text titleText = Text(widget.title, style: Theme.of(context).textTheme.button);

    if(widget.isVertical) {
      return RotatedBox(
        quarterTurns: widget.quarterTurns,
        child: Column(
          children: [
            SizedBox(height: 18),
            FadeTransition(
              opacity: _iconFadeAnimation,
              child: widget.icon,
            ),
            SizedBox(height: 12),
            FadeTransition(
              opacity: _titleFadeAnimation,
              child: SizeTransition(
                sizeFactor: _titleSizeAnimation,
                axis: Axis.vertical,
                axisAlignment: -1,
                child: Center(child: ExcludeSemantics(child: titleText)),
              ),
            ),
            SizedBox(height: 18),
          ],
        ),
      );
    } else {
      final width = MediaQuery.of(context).size.width;
      final expandedTitleWidthMultiplier = 2;
      final unitWidth = (width - widget.leftOrTopPadding)
          / (widget.tabCount + expandedTitleWidthMultiplier);

      return RotatedBox(
        quarterTurns: widget.quarterTurns,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 56),
          child: Row(
            children: [
              FadeTransition(
                opacity: _iconFadeAnimation,
                child: SizedBox(
                  width: unitWidth,
                  child: widget.icon,
                ),
              ),
              FadeTransition(
                opacity: _titleFadeAnimation,
                child: SizeTransition(
                  sizeFactor: _titleSizeAnimation,
                  axis: Axis.horizontal,
                  axisAlignment: -1,
                  child: SizedBox(
                    width: unitWidth * expandedTitleWidthMultiplier,
                    child: ExcludeSemantics(child: titleText),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
