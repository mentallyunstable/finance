/// High-level service for voice → domain transformation
class VoiceService {
  // final VoicePlatform _platform = VoicePlatform.instance;

  // /// Stream of parsed voice commands
  // Stream<VoiceCommand> get commands {
  //   return _platform.onResult
  //       .map((event) => _safeParse(event.text))
  //       .where((command) => command != null)
  //       .cast<VoiceCommand>();
  // }
  //
  // /// Stream of transactions (ready for Finance domain)
  // Stream<Transaction> get transactions {
  //   return commands
  //       .where((command) => command is CreateTransactionCommand)
  //       .map((command) => _mapToTransaction(command as CreateTransactionCommand));
  // }
  //
  // /// Start listening with optional config
  // Future<void> start({VoiceConfig? config}) async {
  //   await _platform.initialize();
  //   await _platform.startListening();
  // }
  //
  // /// Stop listening
  // Future<void> stop() {
  //   return _platform.stopListening();
  // }
  //
  // /// Internal safe parser wrapper
  // VoiceCommand? _safeParse(String text) {
  //   try {
  //     return VoiceParser.parse(text);
  //   } catch (_) {
  //     return null;
  //   }
  // }
  //
  // /// Map command → domain entity
  // Transaction _mapToTransaction(CreateTransactionCommand cmd) {
  //   return Transaction(
  //     title: cmd.merchant,
  //     amount: cmd.amount,
  //     currency: cmd.currency,
  //     category: cmd.category,
  //     createdAt: DateTime.now(),
  //   );
  // }
}
