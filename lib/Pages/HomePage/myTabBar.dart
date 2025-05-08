import 'package:flutter/material.dart';

PreferredSizeWidget myTabBar(TabController tabController, BuildContext context) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(60),
    child: TabBar(
      controller: tabController,
      indicatorWeight: 5,
      indicatorSize: TabBarIndicatorSize.label,
      indicator: BoxDecoration(borderRadius: BorderRadius.circular(100)),
      labelStyle: Theme.of(context).textTheme.bodyLarge,
      unselectedLabelStyle: Theme.of(context).textTheme.labelLarge,
      tabs: const [
        Tab(text: "Chats"),
        Tab(text: "Groups"),
        Tab(text: "Calls"),
      ],
    ),
  );
}
