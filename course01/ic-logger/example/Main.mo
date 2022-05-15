import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Result "mo:base/Result";
import RBT "mo:base/RBTree"; //RB树的库文件
import Principal "mo:base/Principal";
import Logger "mo:ic-logger/Logger";
import MyLoggers "MyLoggers";

actor class Main() {
    
    private stable var logger_index : Nat = 0;
    private let Bs = RBT.RBTree<Nat, Principal>(Nat.compare); //存储创建的canister

    // Add a set of messages to the log.
    public shared (msg) func append(msgs: [Text]): async () {
        let principal : ?Principal  = Bs.get(logger_index);
        let id : Principal = switch (principal) {
            case null { assert false };
            case (?p) { p };
        };
        let curLogger : MyLoggers.MyLogger = actor(Principal.toText(id));
        if(curLogger.getSize() < 100){
            curLogger.append(msgs);
        } else {
            let newLogger = await MyLoggers.MyLogger();
            await newLogger.append(msgs);
            let principal = Principal.fromActor(newLogger);
            Bs.put(logger_index, principal);
            logger_index += 1;
        }
    };

  // Return the messages between from and to indice (inclusive).
  public shared query (msg) func view(from: Nat, to: Nat) : async Logger.View<Text> {
    let principal : ?Principal  = Bs.get(logger_index);
    let id : Principal = switch (principal) {
        case null { assert false };
        case (?p) { p };
    };
    let curLogger : MyLoggers.MyLogger = actor(Principal.toText(id));
    curLogger.view(from, to)
  };
}
