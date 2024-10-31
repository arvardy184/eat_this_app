class ChatChannelUtil {
  static String createChannelName(String key1, String key2) {
    // Sort keys lexicographically
    final sortedKeys = [key1, key2]..sort((a, b) => a.compareTo(b));
    print("Cek conv key : ${sortedKeys[0]} - ${sortedKeys[1]}");
    print("cek key $key1 & $key2");
    return 'chat.${sortedKeys[0]}.${sortedKeys[1]}';
  }
}