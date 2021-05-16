import 'package:flutter/material.dart';
import '../utils/adaptive.dart';
import '../utils/routes.dart';
import 'pageViews/overviewPageView.dart';
import 'pageViews/calendarPageView.dart';
import 'pageViews/locationsPageView.dart';
import 'pageViews/reportsPageView.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, RestorationMixin {
  PageController _pageViewController = PageController();
  RestorableInt _pageViewIndex = RestorableInt(0);
  
  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  String get restorationId => 'home_page';

  @override
  void restoreState(RestorationBucket oldBucket, bool initialRestore) {
    registerForRestoration(_pageViewIndex, 'page_index');
  }

  @override
  Widget build(BuildContext context) {
    final bool isPortrait = isDisplayPortrait(context);

    return SafeArea(
      top: true,
      bottom: true,
      child: Scaffold(
        appBar: AppBar(),
        drawer: Drawer(
          child: _buildDrawerItems(),
        ),
        body: PageView(
          controller: _pageViewController,
          children: _buildPageViews(),
          onPageChanged: (index) => setState(() => _pageViewIndex.value = index),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _pageViewIndex.value,
          showUnselectedLabels: false,
          selectedItemColor: Theme.of(context).textTheme.bodyText1.color,
          unselectedItemColor: Theme.of(context).textTheme.bodyText1.color.withOpacity(0.5),
          onTap: (index) => _pageViewController.animateToPage(
            index,
            duration: Duration(milliseconds: 200),
            curve: Curves.bounceOut
          ),
          items: _buildNavigationBarItems(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){Navigator.of(context).pushNamed(AppRoute.add);},
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildDrawerItems() => ListView(
    children: [
      UserAccountsDrawerHeader(
        accountName: Text('user'),
        accountEmail: Text('email'),
        currentAccountPicture: CircleAvatar(child: FlutterLogo()),
      ),
    ],
  );

  List<Widget> _buildPageViews() => [
    OverviewPageView(),
    CalendarPageView(),
    LocationsPageView(),
    ReportsPageView(),
  ];

  List<BottomNavigationBarItem> _buildNavigationBarItems() => [
    BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Overview"),
    BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Calendar"),
    BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined), label: "Locations"),
    BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Reports"),
  ];

  @override
  void dispose() {
    _pageViewController.dispose();
    _pageViewIndex.dispose();
    super.dispose();
  }
}
