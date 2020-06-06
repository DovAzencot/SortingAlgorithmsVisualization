import 'package:flutter/material.dart';

import 'modals.dart';


int nombreTri = 10;
int speed = 100;

const Color primary = Color(0xff1a3e59);
const Color primaryDark = Color(0xff470938);
const Color accent = Color(0xffffffff);
const Color activeData = Color(0xff1DD75F);

//AlgorithmTitles
const String bubbleSortTitle = 'Bubble Sort';
const String selectionSortTitle = 'Selection Sort';
const String insertionSortTitle = 'Insertion Sort';

//ComplexityString
const bigOh = 'O';
const logN = 'log(n)';
const nsquare = 'n2';
const logNsquare = 'log(n2)';

//Algorithms
final List<SortingAlgorithm> sortingAlgorithmsList = [
  SortingAlgorithm(
    title: selectionSortTitle,
    complexity: nsquare,
  ),
  SortingAlgorithm(
    title: insertionSortTitle,
    complexity: nsquare,
  ),
  SortingAlgorithm(
    title: bubbleSortTitle,
    complexity: logNsquare,
  ),
];
