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
    // Add a set of messages to the log.
    public shared (msg) func append(msgs: [Text]): async () {
        let curLogger : ?MyLogger  = Bs.get(logger_index);
        switch (curLogger) {
            case (?_curLogger) { 
                let size: Nat = await _curLogger.getSize();
                if(size < 100){
                    await _curLogger.append(msgs);
                } else {
                    var newLogger: MyLogger = await MyLoggers.MyLogger(?8);
                    await newLogger.append(msgs);
                    Bs.put(logger_index, newLogger);
                }
             };
            case null { };
        };
        
    };

  // Return the messages between from and to indice (inclusive).
  public shared (msg) func view(from: Nat, to: Nat) : async Logger.View<Text> {
    let curLogger : ?MyLogger  = Bs.get(logger_index);
    switch (curLogger) {
        case (?_curLogger) { 
            await _curLogger.view(from, to);
         };
        case null {
            {
                start_index : Nat = 0;
                messages = [""];
            }
         };
    };
    
  };
}
