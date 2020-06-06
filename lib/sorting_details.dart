import 'package:flutter/material.dart';
import 'constants.dart';
import 'widgets.dart';
import 'custom_slider_thumb_circle.dart';

List<int> numbers;
List<int> pointers = [];
int n;
String updateText, selectedAlgorithm = sortingAlgorithmsList[0].title;
bool disableButtons = false, isSelectingDelay = false, isCancelled = false;
double _delay = 2;



class SortDetailsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SortDetailsScreenState();
}

class SortDetailsScreenState extends State<SortDetailsScreen> {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    numbers = new List<int>.generate(nombreTri, (i) => i + 1);
    n = numbers.length;
    shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        color: primary,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            AppBar(
              centerTitle: true,
              title: Text('Sorting Algorithms'),
              elevation: 0,
              backgroundColor: primary,
            ),
            SoringAlgorithmsList(
              isDisabled: disableButtons,
              onTap: (selected) {
                selectedAlgorithm = selected;
              },
            ),
            Expanded(
              flex: 4,
              child: ChartWidget(
                numbers: numbers,
                activeElements: pointers,
              ),
            ),
            BottomPointer(
              length: numbers.length,
              pointers: pointers,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    updateText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Numbers of elements to sort", style: TextStyle(color: Colors.white)),
        ),
            SliderWidgetSpeed(fullWidth: true,  max: 200, min:  10,),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text("Milliseconds of delay between each step", style: TextStyle(color: Colors.white)),
            ),
            SliderWidget(fullWidth: true,  max: 100, min:  0,),
            SizedBox(height: 8,),
            bottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget bottomButtons() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          FloatingActionButton.extended(
            heroTag: 'sort',
            backgroundColor: primaryDark,
            label: Text(disableButtons ? 'Cancel' : 'Sort'),
            icon: Icon(disableButtons ? Icons.stop : Icons.play_circle_outline),
            onPressed: () {
              if (disableButtons) {
                setState(() {
                  isCancelled = true;
                });
              } else {
                selectWhichSorting();
              }
            },
          ),
          FloatingActionButton.extended(
            heroTag: 'shuffle',
            backgroundColor: disableButtons ? Colors.black : primaryDark,
            label: Text('Shuffle'),
            icon: Icon(Icons.shuffle),
            onPressed: () => disableButtons ? null : shuffle(),
          ),
        ],
      ),
    );
  }

  void selectWhichSorting() {
    switch (selectedAlgorithm) {
      case bubbleSortTitle:
        bubbleSort();
        break;
      case selectionSortTitle:
        selectionSort();
        break;
      case insertionSortTitle:
        insertionSort();
        break;
      default:
        break;
    }
  }

  Widget Slider1() {
    return Slider(
      min: 10,
      max: 100,
      label: '$nombreTri',
      divisions: 90,
      value: nombreTri.toDouble(),
      onChanged: (value) {

        setState(() {
          isCancelled = true;
          nombreTri = value.toInt();
          numbers = new List<int>.generate(nombreTri, (i) => i + 1);
          n = numbers.length;
          shuffle();
        });
      },
    );
  }

  void shuffle() {
    setState(() {
      updateText = 'Press the sort button to start sorting';
      numbers.shuffle();
    });
  }

  void updatePointers(List<int> currentPointers) {
    setState(() {
      pointers = currentPointers;
    });
  }

  void finishedSorting() {
    setState(() {
      updateText = 'Sorting Completed';
      disableButtons = false;
    });
  }

  void cancelledSorting() {
    setState(() {
      updateText = 'Sorting Cancelled';
      disableButtons = false;
    });
  }

  void startSorting() {
    setState(() {
      isCancelled = false;
      disableButtons = true;
      isSelectingDelay = false;
    });
  }

  void setUpdateText(String text) {
    setState(() {
      updateText = text;
    });
  }

  void swap(numbers, i, j) {
    int temp = numbers[i];
    numbers[i] = numbers[j];
    numbers[j] = temp;
  }

  //Bubble Sort
  void bubbleSort() async {
    startSorting();
    int i, step;
    for (step = 0; step < n; step++) {
      if (isCancelled) break;
      for (i = 0; i < n - step - 1; i++) {
        if (isCancelled) break;
        updatePointers([i, i + 1]);
        setUpdateText('Is ${numbers[i]} > ${numbers[i + 1]} ?');
        await Future.delayed(Duration(milliseconds: (_delay ~/ 2).toInt()));
        if (numbers[i] > numbers[i + 1]) {
          swap(numbers, i, i + 1);
          setUpdateText('Yes, so swapping.');
        } else {
          setUpdateText('No, so no need to swap.');
        }
        await Future.delayed(Duration(milliseconds: (_delay ~/ 2).toInt()));
      }
    }
    isCancelled ? cancelledSorting() : finishedSorting();
  }

  //SelectionSort
  void selectionSort() async {
    startSorting();
    // One by one move boundary of unsorted subnumbersay
    for (int i = 0; i < n - 1; i++) {
      if (isCancelled) break;
      // Find the minimum element in unsorted numbersay
      int minIdx = i;
      setUpdateText('Finding minimum');
      for (int j = i + 1; j < n; j++) {
        if (isCancelled) break;
        updatePointers([i, j]);
        await Future.delayed(Duration(milliseconds: speed));
        if (numbers[j] < numbers[minIdx]) minIdx = j;
      }

      // Swap the found minimum element with the first element
      updatePointers([minIdx, i]);
      setUpdateText(
          'Swapping minimum element ${numbers[minIdx]} and ${numbers[i]}');
      await Future.delayed(Duration(milliseconds: speed));
      swap(numbers, minIdx, i);
    }
    isCancelled ? cancelledSorting() : finishedSorting();
  }

  //Insertion Sort
  void insertionSort() async {
    startSorting();
    int i, key, j;
    updatePointers([0]);
    setUpdateText('Assume first element to be already sorted');
    await Future.delayed(Duration(milliseconds: speed));
    for (i = 1; i < n; i++) {
      if (isCancelled) break;
      updatePointers([i]);
      setUpdateText('Taking ${numbers[i]} as key element.');
      await Future.delayed(Duration(milliseconds: speed));
      key = numbers[i];
      j = i - 1;

      while (j >= 0 && numbers[j] > key) {
        updatePointers([numbers.indexOf(key), j]);
        setUpdateText(
            'Since $key < ${numbers[j]} so, inserting it one place before.');
        await Future.delayed(Duration(milliseconds: speed));

        swap(numbers, j + 1, j);
        updatePointers([numbers.indexOf(key)]);
        await Future.delayed(Duration(milliseconds: speed));
        j = j - 1;
      }
      numbers[j + 1] = key;
    }
    isCancelled ? cancelledSorting() : finishedSorting();
  }

}

class SliderWidget extends StatefulWidget {
  final double sliderHeight;
  final int min;
  final int max;
  final fullWidth;

  SliderWidget(
      {this.sliderHeight = 48,
        this.max = 10,
        this.min = 0,
        this.fullWidth = false});

  @override
  _SliderWidgetState createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {

  @override
  Widget build(BuildContext context) {
    double paddingFactor = .2;

    if (this.widget.fullWidth) paddingFactor = .3;

    return Container(
        width: this.widget.fullWidth
            ? double.infinity
            : (this.widget.sliderHeight) * 5.5,
        height: (this.widget.sliderHeight) *0.8,
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.all(
            Radius.circular((this.widget.sliderHeight * .3)),
          ),
          gradient: new LinearGradient(
              colors: [
                primaryDark,
                primaryDark,
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 1.00),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(this.widget.sliderHeight * paddingFactor,
              2, this.widget.sliderHeight * paddingFactor, 2),
          child: Row(
            children: <Widget>[
              Text(
                '${this.widget.min}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: this.widget.sliderHeight * .3,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,

                ),
              ),
              SizedBox(
                width: this.widget.sliderHeight * .1,
              ),
              Expanded(
                child: Center(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.white.withOpacity(1),
                      inactiveTrackColor: Colors.white.withOpacity(.5),

                      trackHeight: 4.0,
                      thumbShape: CustomSliderThumbCircle(
                        thumbRadius: this.widget.sliderHeight * .4,
                        min: this.widget.min,
                        max: this.widget.max,
                      ),
                      overlayColor: Colors.white.withOpacity(.4),
                      //valueIndicatorColor: Colors.white,
                      activeTickMarkColor: Colors.white,
                      inactiveTickMarkColor: Colors.red.withOpacity(.7),
                    ),
                    child: Slider(
                      min: 0,
                      max: 100,
                      value: speed.toDouble(),
                      onChanged: (value) {
                        setState(() {
                          speed = value.toInt();
                        });
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: this.widget.sliderHeight * .1,
              ),
              Text(
                '${this.widget.max}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: this.widget.sliderHeight * .3,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
  }

}


class SliderWidgetSpeed extends StatefulWidget {
  final double sliderHeight;
  final int min;
  final int max;
  final fullWidth;

  SliderWidgetSpeed(
      {this.sliderHeight = 48,
        this.max = 10,
        this.min = 10,
        this.fullWidth = false});

  @override
  _SliderWidgetSpeedState createState() => _SliderWidgetSpeedState();
}

class _SliderWidgetSpeedState extends State<SliderWidgetSpeed> {

  @override
  Widget build(BuildContext context) {
    double paddingFactor = .2;

    if (this.widget.fullWidth) paddingFactor = .3;

    return Container(
      width: this.widget.fullWidth
          ? double.infinity
          : (this.widget.sliderHeight) * 5.5,
      height: (this.widget.sliderHeight)*0.8,
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.all(
          Radius.circular((this.widget.sliderHeight * .3)),
        ),
        gradient: new LinearGradient(
            colors: [
              primaryDark,
              primaryDark,
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 1.00),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(this.widget.sliderHeight * paddingFactor,
            2, this.widget.sliderHeight * paddingFactor, 2),
        child: Stack(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  '${this.widget.min}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: this.widget.sliderHeight * .3,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,

                  ),
                ),
                SizedBox(
                  width: this.widget.sliderHeight * .1,
                ),
                Expanded(
                  child: Center(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Colors.white.withOpacity(1),
                        inactiveTrackColor: Colors.white.withOpacity(.5),

                        trackHeight: 4.0,
                        thumbShape: CustomSliderThumbCircle(
                          start: 10,
                          thumbRadius: this.widget.sliderHeight * .4,
                          min: this.widget.min,
                          max: this.widget.max,
                        ),
                        overlayColor: Colors.white.withOpacity(.4),
                        //valueIndicatorColor: Colors.white,
                        activeTickMarkColor: Colors.white,
                        inactiveTickMarkColor: Colors.red.withOpacity(.7),
                      ),
                      child: Slider(
                        min: 10,
                        max: 200,
                        divisions: 190,
                        value: nombreTri.toDouble(),
                        onChanged: (value) {

                          setState(() {
                            isCancelled = true;
                            nombreTri = value.toInt();
                            numbers = new List<int>.generate(nombreTri, (i) => i + 1);
                            n = numbers.length;
                            numbers.shuffle();
                          });
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: this.widget.sliderHeight * .1,
                ),
                Text(
                  '${this.widget.max}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: this.widget.sliderHeight * .3,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        )
      ),
    );
  }
}

