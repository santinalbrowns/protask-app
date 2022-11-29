import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:app/dashboard/bloc/projects_bloc.dart';
import 'package:app/project/models/models.dart';
import 'package:app/project/project.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final String title = 'Dashboard';

  late int showingTooltip;

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color.fromARGB(255, 153, 153, 161),
      fontSize: 10,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = "JAN";
        break;
      case 1:
        text = "FEB";
        break;
      case 2:
        text = "MAR";
        break;
      case 3:
        text = "APR";
        break;
      case 4:
        text = "MAY";
        break;
      case 5:
        text = "JUN";
        break;
      case 6:
        text = "JUL";
        break;
      case 7:
        text = "AUG";
        break;
      case 8:
        text = "SEP";
        break;
      case 9:
        text = "OCT";
        break;
      case 10:
        text = "NOV";
        break;
      case 11:
        text = "DEC";
        break;
      default:
        text = "";
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  BarChartGroupData generateGroupData(int x, int y) {
    return BarChartGroupData(
      x: x,
      showingTooltipIndicators: showingTooltip == x ? [0] : [],
      groupVertically: true,
      barRods: [
        BarChartRodData(
          toY: y.toDouble(),
          color: Colors.blue,
        ),
      ],
    );
  }

  @override
  void initState() {
    showingTooltip = -1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.read<ProjectsBloc>().add(GetProjects());
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.white,
            actions: [
              IconButton(
                onPressed: () {
                  //Navigator.pushNamed(context, AddProjectPage.route);
                  _navigateAndDisplayProject(context);
                },
                icon: const Icon(Icons.add),
                color: Colors.blueAccent,
              )
            ],
            title: const Text(
              'Dashboard',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            pinned: true,
            floating: true,
            elevation: 0,
          ),
          /* SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 35, vertical: 20.0),
              child: AspectRatio(
                aspectRatio: 2,
                child: BarChart(
                  BarChartData(
                      alignment: BarChartAlignment.spaceBetween,
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(),
                        rightTitles: AxisTitles(),
                        topTitles: AxisTitles(),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: bottomTitles,
                            //reservedSize: 16,
                          ),
                        ),
                      ),
                      barGroups: [
                        generateGroupData(0, 5),
                        generateGroupData(1, 13),
                        generateGroupData(2, 23),
                        generateGroupData(3, 15),
                        generateGroupData(4, 30),
                        generateGroupData(5, 6),
                        generateGroupData(6, 23),
                        generateGroupData(7, 18),
                        generateGroupData(8, 12),
                      ],
                      borderData: FlBorderData(show: false),
                      gridData: FlGridData(show: false),
                      barTouchData: BarTouchData(
                        enabled: false,
                      )),
                ),
              ),
            ),
          ), */
          const SliverToBoxAdapter(
            child: Padding(
              padding:
                  EdgeInsets.only(left: 15, right: 15, top: 25, bottom: 10),
              child: Text(
                'Projects',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          BlocBuilder<ProjectsBloc, ProjectsState>(
            builder: (context, state) {
              if (state is ProjectsLoaded) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          _deletedProjectAndDisplayProject(
                              context, state.projects[index].id);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          padding: const EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.watch_later,
                                              size: 16.0,
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              "Due ${Jiffy(state.projects[index].due).endOf(Units.MONTH).fromNow()}",
                                              style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          state.projects[index].name,
                                          overflow: TextOverflow.ellipsis,
                                          style:
                                              const TextStyle(fontSize: 16.0),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          state.projects[index].description,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.black
                                                  .withOpacity(0.5)),
                                        ),
                                        if (state.projects[index].description
                                            .isNotEmpty)
                                          const SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: LayoutBuilder(builder:
                                        (BuildContext context,
                                            BoxConstraints constraints) {
                                      return CircularPercentIndicator(
                                        radius: 25.0,
                                        lineWidth: 4.0,
                                        percent: state.projects[index].progress,
                                        circularStrokeCap:
                                            CircularStrokeCap.round,
                                        center: Text(
                                          "${(state.projects[index].progress * 100).ceil().toString()}%",
                                          style:
                                              const TextStyle(fontSize: 12.0),
                                        ),
                                        backgroundColor:
                                            Colors.blue.withOpacity(0.3),
                                        progressColor: Colors.blue,
                                      );
                                    }),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.calendar_month_outlined,
                                    size: 16.0,
                                    color: Colors.black.withOpacity(0.3),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    Jiffy(state.projects[index].createdAt)
                                        .yMMMMd,
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.3),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: state.projects.length,
                  ),
                );
              }

              return const SliverToBoxAdapter(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _navigateAndDisplayProject(BuildContext context) async {
    final result = await Navigator.pushNamed(context, AddProjectPage.route);

    if (!mounted) return;

    if (result != null) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('$result')));
    }
  }

  Future<void> _deletedProjectAndDisplayProject(
      BuildContext context, String id) async {
    final result = await Navigator.pushNamed(context, ProjectPage.route,
        arguments: ProjectArgs(id: id));

    if (!mounted) return;

    if (result != null) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('$result')));
    }
  }
}
