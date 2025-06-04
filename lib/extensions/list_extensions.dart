extension IterableExtension<T> on Iterable<T> {
  Iterable<T> distinctBy(Object getCompareValue(T e)) {
    var result = <T>[];
    this.forEach((element) {
      if (!result.any((x) => getCompareValue(x) == getCompareValue(element)))
        result.add(element);
    });

    return result;
  }
}
