import 'package:flutter/material.dart';

class MindmapGraphView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MindmapGraph(),
    );
  }
}

class MindmapGraph extends StatefulWidget {
  @override
  MindmapGraphState createState() => MindmapGraphState();
}

class MindmapGraphState extends State<MindmapGraph> {

  List<int> values = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: values.length,
          itemBuilder: (BuildContext context, int index) =>
              BorderContainer(values: values, value: values[index])),
    );
  }
}

class BorderContainer extends StatefulWidget {
  final int value;
  final List<int> values;

  const BorderContainer({Key key, this.values, this.value}) : super(key: key);

  @override
  _BorderContainerState createState() => _BorderContainerState();
}

class _BorderContainerState extends State<BorderContainer> {
  int count = 0;
  bool flag = true;
  var innerBorder, outerBorder;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var futureWithTheLoop = () async {
      while (flag){
        count++;
        if(mounted) {
          setState(() {
            outerBorder = Border.all(
                width: 3.0,
                color: widget.value == count ? Colors.grey : Colors.grey
                    .withOpacity(0));

            innerBorder = Border.all(
                width: 1.0,
                color: widget.value == count
                    ? Colors.grey.withOpacity(0)
                    : Colors.grey.withOpacity(0.3));
          });
        }

        if(count == widget.values.length){
          count = 0;
        }

        await Future.delayed(Duration(seconds: 15));
      }
    }();

    Future.wait([futureWithTheLoop]);

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            border: outerBorder, borderRadius: BorderRadius.circular(16)),
        child: GestureDetector(
          child: Container(
              decoration: BoxDecoration(
                  border: innerBorder, borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Text('${widget.value}'),
                    Text('Another item in container number: ${widget.value}')
                  ],
                ),
              ),
          ),
        ),
      ),
    );
  }
}
