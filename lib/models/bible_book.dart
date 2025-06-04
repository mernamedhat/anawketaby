/*
 * Copyright (c) 2021 Shady Boshra.
 * IN: https://LinkedIn.com/in/ShadyBoshra2012
 * GitHub: https://github.com/ShadyBoshra2012
 * Mostaql: https://mostaql.com/u/ShadyBoshra2012
 */

import 'package:anawketaby/enums/bible_testaments.dart';

class BibleBook {
  int? order;
  String? key;
  String? short;
  String? name;
  BibleTestaments? testament;
  int? chaptersNo;

  BibleBook(
      {this.order,
      this.key,
      this.short,
      this.name,
      this.testament,
      this.chaptersNo});

  String toString() {
    return "Book($order, $key, $short, $name, $testament, $chaptersNo)";
  }
}
