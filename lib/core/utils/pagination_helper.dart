class PaginationHelper<T> {
  final int pageSize;
  int currentPage = 0;
  bool hasMore = true;

  PaginationHelper({this.pageSize = 20});

  List<T> paginate(List<T> items) {
    final startIndex = currentPage * pageSize;
    final endIndex = startIndex + pageSize;

    if (startIndex >= items.length) {
      hasMore = false;
      return [];
    }

    final paginatedItems = items.sublist(
      startIndex,
      endIndex > items.length ? items.length : endIndex,
    );

    hasMore = endIndex < items.length;
    return paginatedItems;
  }

  void nextPage() {
    if (hasMore) {
      currentPage++;
    }
  }

  void reset() {
    currentPage = 0;
    hasMore = true;
  }
}

