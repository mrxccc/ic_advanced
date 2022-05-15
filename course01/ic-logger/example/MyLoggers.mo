import Nat "mo:base/Nat";
import Logger "mo:ic-logger/Logger";

actor class MyLogger() {

  stable var state : Logger.State<Text> = Logger.new<Text>(0, null);
  let logger = Logger.Logger<Text>(state);
  private stable var size : Nat = 0;

  // Add a set of messages to the log.
  public shared (msg) func append(msgs: [Text]) {
    logger.append(msgs);
    size += 1
  };

  // Return log stats, where:
  //   start_index is the first index of log message.
  //   bucket_sizes is the size of all buckets, from oldest to newest.
  public query func stats() : async Logger.Stats {
    logger.stats()
  };

  // Return the messages between from and to indice (inclusive).
  public shared query (msg) func view(from: Nat, to: Nat) : async Logger.View<Text> {
    logger.view(from, to)
  };

    // Return the messages between from and to indice (inclusive).
  public shared query (msg) func getSize() : async Nat {
    size
  };
}
