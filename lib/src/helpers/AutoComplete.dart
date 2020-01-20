class AutoComplete {
  RegExp _camelSplitter = RegExp("(?:^|[A-Z]).*?(?=[A-Z]|\$)");
  List<String> test;
  List<String> _words;

  AutoComplete()
  {
      _words = new List<String>();
  }

  void addWord(String word)
  {
      _words.add(word);
  }

  List<String> getMatches(String partial)
  {
      return _words.where((x) => _scoreMatch(partial, x)).toList();
  }

  bool _scoreMatch(String partial, String word)
  {
      List<String> matches = _camelSplitter.allMatches(word).map((x) => x.group(0).toLowerCase()).toList();
      return _scoreMatchWithWordList(partial.toLowerCase(), matches);
  }

  bool _scoreMatchWithWordList(String partial, List<String> words)
  {
      for(String word in words)
      {
          if(word.startsWith(partial))
          {
              return true;
          }
      }

      for (int i = 1; i < partial.length;i++)
      {
          String first = partial.substring(0, i);
          String second = partial.substring(i);

          List<String> queue = List<String>.from(words);
          while(queue.length > 1)
          {
              String word = queue.removeAt(0);
              if(word.startsWith(first))
              {
                  if (_scoreMatchWithWordList(second, queue))
                  {
                      return true;
                  }
                  else
                  {
                      break;
                  }
              }
          }
      }

      return false;
  }
}