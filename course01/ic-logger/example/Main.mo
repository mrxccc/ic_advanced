import Nat "mo:base/Nat";
import Text "mo:base/Text";
import List "mo:base/List";
import Result "mo:base/Result";
import RBT "mo:base/RBTree"; //RB树的库文件
import Principal "mo:base/Principal";
import Logger "mo:ic-logger/Logger";
import MyLoggers "MyLoggers";
import Option "mo:base/Option";

actor class Main() {
    
    private stable var logger_index : Nat = 0;
    private let Bs = RBT.RBTree<Nat, MyLogger>(Nat.compare); //存储创建的canister
    type MyLogger = MyLoggers.MyLogger;
    type View = Logger.View<Text>;
    // Add a set of messages to the log.
    public shared (msg) func append(msgs: [Text]): async () {
        let curLogger : ?MyLogger  = Bs.get(logger_index);
        switch (curLogger) {
            case (?_curLogger) { 
                let size: Nat = await _curLogger.getSize();
                if(size < 100){
                    await _curLogger.append(msgs);
                } else {
                    let newLogger: MyLogger = await MyLoggers.MyLogger();
                    await newLogger.append(msgs);
                    logger_index += 1;
                    Bs.put(logger_index, newLogger);
                }
             };
            case null { };
        };
        
    };

  // Return the messages between from and to indice (inclusive).
  public shared query (msg) func view(from: Nat, to: Nat) : async View {
    let curLogger : ?MyLogger  = Bs.get(logger_index);
    switch (curLogger) {
        case (?_curLogger) { 
            await _curLogger.view(from, to);
         };
        case null {
            var messages : List.List<Text> = List.nil();
            var start_index : Nat = 0;
            let l = {
                start_index: start_index;
                messages: messages;
            }
         };
    };
    
  };
}
