import Nat "mo:base/Nat";
import Logger "mo:ic-logger/Logger";

actor class MyLogger(n : ?Nat) {

  stable var state : Logger.State<Text> = Logger.new<Text>(0, n);
  let logger = Logger.Logger<Text>(state);

  // Add a set of messages to the log.
  public shared (msg) func append(msgs: [Text]): async () {
    logger.append(msgs);
  };

  // Return the messages between from and to indice (inclusive).
  public shared (msg) func view(from: Nat, to: Nat) : async Logger.View<Text> {
    logger.view(from, to)
  };

  public query func getSize() : async Nat {
    state.num_of_lines
  };

}