class ChatChannelUtil {
  static String createChannelName(String key1, String key2) {
    final sortedKeys = [key1, key2]..sort((a, b) => a.compareTo(b));
    final channelName = 'chat.${sortedKeys[0]}.${sortedKeys[1]}';
    print("Creating channel name:");
    print("Input keys: $key1, $key2");
    print("Sorted keys: ${sortedKeys[0]}, ${sortedKeys[1]}");
    print("Final channel name: $channelName");
    return channelName;
  }
}