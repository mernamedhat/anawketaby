/*
 * Copyright (c) 2021 Shady Boshra.
 * IN: https://LinkedIn.com/in/ShadyBoshra2012
 * GitHub: https://github.com/ShadyBoshra2012
 * Mostaql: https://mostaql.com/u/ShadyBoshra2012
 */

import 'package:anawketaby/enums/bible_testaments.dart';
import 'package:anawketaby/models/bible_book.dart';

class BibleUtil {
  static final instance = BibleUtil._();

  final List<BibleBook> books = List.empty(growable: true);

  BibleUtil._() {
    var newList = [
      BibleBook(
          order: 1,
          key: "Gen",
          short: "تك",
          name: "تكوين",
          testament: BibleTestaments.old_testament,
          chaptersNo: 50),
      BibleBook(
          order: 2,
          key: "Ex",
          short: "خر",
          name: "خروج",
          testament: BibleTestaments.old_testament,
          chaptersNo: 40),
      BibleBook(
          order: 3,
          key: "Lev",
          short: "لا",
          name: "لاويين",
          testament: BibleTestaments.old_testament,
          chaptersNo: 27),
      BibleBook(
          order: 4,
          key: "Num",
          short: "عد",
          name: "عدد",
          testament: BibleTestaments.old_testament,
          chaptersNo: 36),
      BibleBook(
          order: 5,
          key: "Deut",
          short: "تث",
          name: "تثنية",
          testament: BibleTestaments.old_testament,
          chaptersNo: 34),
      BibleBook(
          order: 6,
          key: "Josh",
          short: "يش",
          name: "يشوع",
          testament: BibleTestaments.old_testament,
          chaptersNo: 24),
      BibleBook(
          order: 7,
          key: "Judg",
          short: "قض",
          name: "قضاة",
          testament: BibleTestaments.old_testament,
          chaptersNo: 21),
      BibleBook(
          order: 8,
          key: "Ruth",
          short: "راع",
          name: "راعوث",
          testament: BibleTestaments.old_testament,
          chaptersNo: 4),
      BibleBook(
          order: 9,
          key: "1Sam",
          short: "1 صم",
          name: "صموئيل الأول",
          testament: BibleTestaments.old_testament,
          chaptersNo: 31),
      BibleBook(
          order: 10,
          key: "2Sam",
          short: "2 صم",
          name: "صموئيل الثاني",
          testament: BibleTestaments.old_testament,
          chaptersNo: 24),
      BibleBook(
          order: 11,
          key: "1Kings",
          short: "1 مل",
          name: "ملوك الأول",
          testament: BibleTestaments.old_testament,
          chaptersNo: 22),
      BibleBook(
          order: 12,
          key: "2Kings",
          short: "2 مل",
          name: "ملوك الثاني",
          testament: BibleTestaments.old_testament,
          chaptersNo: 25),
      BibleBook(
          order: 13,
          key: "1Chron",
          short: "1 أخ",
          name: "أخبار الأيام الأول",
          testament: BibleTestaments.old_testament,
          chaptersNo: 29),
      BibleBook(
          order: 14,
          key: "2Chron",
          short: "2 أخ",
          name: "أخبار الأيام الثاني",
          testament: BibleTestaments.old_testament,
          chaptersNo: 36),
      BibleBook(
          order: 15,
          key: "Ezra",
          short: "عز",
          name: "عزرا",
          testament: BibleTestaments.old_testament,
          chaptersNo: 10),
      BibleBook(
          order: 16,
          key: "Neh",
          short: "نح",
          name: "نحميا",
          testament: BibleTestaments.old_testament,
          chaptersNo: 13),
      BibleBook(
          order: 17,
          key: "Est",
          short: "أس",
          name: "أستير",
          testament: BibleTestaments.old_testament,
          chaptersNo: 10),
      BibleBook(
          order: 18,
          key: "Job",
          short: "أي",
          name: "أيوب",
          testament: BibleTestaments.old_testament,
          chaptersNo: 42),
      BibleBook(
          order: 19,
          key: "Ps",
          short: "مز",
          name: "مزامير",
          testament: BibleTestaments.old_testament,
          chaptersNo: 150),
      BibleBook(
          order: 20,
          key: "Prov",
          short: "أم",
          name: "أمثال",
          testament: BibleTestaments.old_testament,
          chaptersNo: 31),
      BibleBook(
          order: 21,
          key: "Eccles",
          short: "جا",
          name: "جامعة",
          testament: BibleTestaments.old_testament,
          chaptersNo: 12),
      BibleBook(
          order: 22,
          key: "Song",
          short: "نش",
          name: "نشيد الأنشاد",
          testament: BibleTestaments.old_testament,
          chaptersNo: 8),
      BibleBook(
          order: 23,
          key: "Isa",
          short: "إش",
          name: "إشعياء",
          testament: BibleTestaments.old_testament,
          chaptersNo: 66),
      BibleBook(
          order: 24,
          key: "Jer",
          short: "أر",
          name: "أرميا",
          testament: BibleTestaments.old_testament,
          chaptersNo: 52),
      BibleBook(
          order: 25,
          key: "Lam",
          short: "مرا",
          name: "مراثي أرميا",
          testament: BibleTestaments.old_testament,
          chaptersNo: 5),
      BibleBook(
          order: 26,
          key: "Ezek",
          short: "حز",
          name: "حزقيال",
          testament: BibleTestaments.old_testament,
          chaptersNo: 48),
      BibleBook(
          order: 27,
          key: "Dan",
          short: "دا",
          name: "دانيال",
          testament: BibleTestaments.old_testament,
          chaptersNo: 12),
      BibleBook(
          order: 28,
          key: "Hos",
          short: "هو",
          name: "هوشع",
          testament: BibleTestaments.old_testament,
          chaptersNo: 14),
      BibleBook(
          order: 29,
          key: "Joel",
          short: "يؤ",
          name: "يوئيل",
          testament: BibleTestaments.old_testament,
          chaptersNo: 3),
      BibleBook(
          order: 30,
          key: "Amos",
          short: "عا",
          name: "عاموس",
          testament: BibleTestaments.old_testament,
          chaptersNo: 9),
      BibleBook(
          order: 31,
          key: "Obad",
          short: "عو",
          name: "عوبديا",
          testament: BibleTestaments.old_testament,
          chaptersNo: 1),
      BibleBook(
          order: 32,
          key: "Jonah",
          short: "يو",
          name: "يونان",
          testament: BibleTestaments.old_testament,
          chaptersNo: 4),
      BibleBook(
          order: 33,
          key: "Mic",
          short: "مي",
          name: "ميخا",
          testament: BibleTestaments.old_testament,
          chaptersNo: 7),
      BibleBook(
          order: 34,
          key: "Nah",
          short: "نا",
          name: "ناحوم",
          testament: BibleTestaments.old_testament,
          chaptersNo: 3),
      BibleBook(
          order: 35,
          key: "Hab",
          short: "حب",
          name: "حبقوق",
          testament: BibleTestaments.old_testament,
          chaptersNo: 3),
      BibleBook(
          order: 36,
          key: "Zeph",
          short: "صف",
          name: "صفنيا",
          testament: BibleTestaments.old_testament,
          chaptersNo: 3),
      BibleBook(
          order: 37,
          key: "Hag",
          short: "حج",
          name: "حجي",
          testament: BibleTestaments.old_testament,
          chaptersNo: 2),
      BibleBook(
          order: 38,
          key: "Zech",
          short: "زك",
          name: "زكريا",
          testament: BibleTestaments.old_testament,
          chaptersNo: 14),
      BibleBook(
          order: 39,
          key: "Mal",
          short: "ملا",
          name: "ملاخي",
          testament: BibleTestaments.old_testament,
          chaptersNo: 4),
      BibleBook(
          order: 40,
          key: "Matth",
          short: "مت",
          name: "متى",
          testament: BibleTestaments.new_testament,
          chaptersNo: 28),
      BibleBook(
          order: 41,
          key: "Mark",
          short: "مر",
          name: "مرقس",
          testament: BibleTestaments.new_testament,
          chaptersNo: 16),
      BibleBook(
          order: 42,
          key: "Luke",
          short: "لو",
          name: "لوقا",
          testament: BibleTestaments.new_testament,
          chaptersNo: 24),
      BibleBook(
          order: 43,
          key: "John",
          short: "يو",
          name: "يوحنا",
          testament: BibleTestaments.new_testament,
          chaptersNo: 21),
      BibleBook(
          order: 44,
          key: "Acts",
          short: "أع",
          name: "أعمال الرسل",
          testament: BibleTestaments.new_testament,
          chaptersNo: 28),
      BibleBook(
          order: 45,
          key: "Rom",
          short: "رو",
          name: "رومية",
          testament: BibleTestaments.new_testament,
          chaptersNo: 16),
      BibleBook(
          order: 46,
          key: "1Cor",
          short: "1 كو",
          name: "كورونثوس الأولى",
          testament: BibleTestaments.new_testament,
          chaptersNo: 16),
      BibleBook(
          order: 47,
          key: "2Cor",
          short: "2 كو",
          name: "كورونثوس الثانية",
          testament: BibleTestaments.new_testament,
          chaptersNo: 13),
      BibleBook(
          order: 48,
          key: "Gal",
          short: "غل",
          name: "غلاطية",
          testament: BibleTestaments.new_testament,
          chaptersNo: 6),
      BibleBook(
          order: 49,
          key: "Eph",
          short: "أف",
          name: "أفسس",
          testament: BibleTestaments.new_testament,
          chaptersNo: 6),
      BibleBook(
          order: 50,
          key: "Phil",
          short: "في",
          name: "فيلبي",
          testament: BibleTestaments.new_testament,
          chaptersNo: 4),
      BibleBook(
          order: 51,
          key: "Col",
          short: "كو",
          name: "كولوسي",
          testament: BibleTestaments.new_testament,
          chaptersNo: 4),
      BibleBook(
          order: 52,
          key: "1Thess",
          short: "1 تس",
          name: "تسالونيكي الأولى",
          testament: BibleTestaments.new_testament,
          chaptersNo: 5),
      BibleBook(
          order: 53,
          key: "2Thess",
          short: "2 تس",
          name: "تسالونيكي الثانية",
          testament: BibleTestaments.new_testament,
          chaptersNo: 3),
      BibleBook(
          order: 54,
          key: "1Tim",
          short: "1 تي",
          name: "تيموثاوس الأولى",
          testament: BibleTestaments.new_testament,
          chaptersNo: 6),
      BibleBook(
          order: 55,
          key: "2Tim",
          short: "2 تي",
          name: "تيموثاوس الثانية",
          testament: BibleTestaments.new_testament,
          chaptersNo: 4),
      BibleBook(
          order: 56,
          key: "Titus",
          short: "تي",
          name: "تيطس",
          testament: BibleTestaments.new_testament,
          chaptersNo: 3),
      BibleBook(
          order: 57,
          key: "Philem",
          short: "في",
          name: "فيلمون",
          testament: BibleTestaments.new_testament,
          chaptersNo: 1),
      BibleBook(
          order: 58,
          key: "Heb",
          short: "عب",
          name: "عبرانيين",
          testament: BibleTestaments.new_testament,
          chaptersNo: 13),
      BibleBook(
          order: 59,
          key: "James",
          short: "يع",
          name: "يعقوب",
          testament: BibleTestaments.new_testament,
          chaptersNo: 5),
      BibleBook(
          order: 60,
          key: "1Pet",
          short: "1 بط",
          name: "بطرس الأولى",
          testament: BibleTestaments.new_testament,
          chaptersNo: 5),
      BibleBook(
          order: 61,
          key: "2Pet",
          short: "2 بط",
          name: "بطرس الثانية",
          testament: BibleTestaments.new_testament,
          chaptersNo: 3),
      BibleBook(
          order: 62,
          key: "1John",
          short: "1 يو",
          name: "يوحنا الأولى",
          testament: BibleTestaments.new_testament,
          chaptersNo: 5),
      BibleBook(
          order: 63,
          key: "2John",
          short: "2 يو",
          name: "يوحنا الثانية",
          testament: BibleTestaments.new_testament,
          chaptersNo: 1),
      BibleBook(
          order: 64,
          key: "3John",
          short: "3 يو",
          name: "يوحنا الثالثة",
          testament: BibleTestaments.new_testament,
          chaptersNo: 1),
      BibleBook(
          order: 65,
          key: "Jude",
          short: "يه",
          name: "يهوذا",
          testament: BibleTestaments.new_testament,
          chaptersNo: 1),
      BibleBook(
          order: 66,
          key: "Rev",
          short: "رؤ",
          name: "رؤيا يوحنا",
          testament: BibleTestaments.new_testament,
          chaptersNo: 22)
    ];

    books.addAll(newList);
  }

  static String readFromBook(BibleBook book, {int? chapter, int? verse}) {
    String value = "${book.key}";

    if (chapter != null) value += "_$chapter";
    if (verse != null) value += "_$verse";

    return value;
  }

  static String readFromKey(String key) {
    List<String> keys = key.split("_");

    BibleBook book =
        BibleUtil.instance.books.firstWhere((e) => e.key == keys[0]);

    String value = "${book.name}";

    if (keys.length > 1) value += " ${keys[1]}";
    if (keys.length > 2) value += ": ${keys[2]}";

    return value;
  }

  static bool isKeyBookOnly(String key) {
    List<String> keys = key.split("_");
    return keys.length == 1;
  }
}
