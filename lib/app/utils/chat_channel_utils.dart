class ChatChannelUtil {
  static String createChannelName(String key1, String key2) {
    // Sort berdasarkan string comparison seperti di backend
    final firstId = key1.compareTo(key2) < 0 ? key1 : key2;
    final secondId = key1.compareTo(key2) < 0 ? key2 : key1;
    
    print("Channel Creation Debug:");
    print("Input keys: $key1, $key2");
    print("First ID: $firstId");
    print("Second ID: $secondId");
    
    return 'chat.$firstId.$secondId';
  }
}