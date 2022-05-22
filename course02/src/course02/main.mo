import IC "./ic";
import Principal "mo:base/Principal";
import Nat8 "mo:base/Nat8";
import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Nat "mo:base/Nat";
import Option "mo:base/Option";
import Debug "mo:base/Debug";

actor class() = self {
    public type Owner = Principal;
    var ownerList : [Owner] = [];
    var M : Nat = 0;
    var N : Nat = 0;

    public shared (msg) func create_canister() : async IC.canister_id {
        // caller should be one of the owners
        assert(owner_check(msg.caller));
        let settings = {
            freezing_threshold = null;
            controllers = ?[Principal.fromActor(self)];
            memory_allocation = null;
            compute_allocation = null;
        };
        let ic : IC.Self = actor("aaaaa-aa");
        let result = await ic.create_canister({settings = ?settings});
        result.canister_id
    };

    public shared (msg) func delete_canister(canister_id : Principal) : async () {
        // caller should be one of the owners
        assert(owner_check(msg.caller));
        let ic : IC.Self = actor("aaaaa-aa");
        await ic.delete_canister({
            canister_id = Option.unwrap(?canister_id);
        });
    };

    public shared (msg) func install_code(canister_id : Principal, wasm_code: ?Blob) : async () {
        // caller should be one of the owners
        assert(owner_check(msg.caller));
        assert(Option.isSome(wasm_code));
        let ic : IC.Self = actor("aaaaa-aa");
        await ic.install_code({
            arg = [];
            wasm_module = Blob.toArray(Option.unwrap(wasm_code));
            mode = #install;
            canister_id = Option.unwrap(?canister_id);
        });
    };

    public shared (msg) func stop_canister(canister_id : Principal) : async () {
        // caller should be one of the owners
        assert(owner_check(msg.caller));
        let ic : IC.Self = actor("aaaaa-aa");
        await ic.stop_canister({
            canister_id = Option.unwrap(?canister_id);
        });
    };

    public shared (msg) func start_canister(canister_id : Principal) : async () {
        // caller should be one of the owners
        assert(owner_check(msg.caller));
        let ic : IC.Self = actor("aaaaa-aa");
        await ic.start_canister({
            canister_id = Option.unwrap(?canister_id);
        });
    };

    func owner_check(owner : Owner) : Bool {
        Option.isSome(Array.find(ownerList, func (a: Owner) : Bool { Principal.equal(a, owner) }))
    };

    public query func get_owner_list() : async [Owner] {
        ownerList
    };

    public shared (msg) func init(list : [Owner], m : Nat) : async Nat {
        assert(m <= list.size() and m >= 1);

        if (ownerList.size() != 0) {
            return M
        };

        ownerList := list;
        M := m;
        N := list.size();

        Debug.print(debug_show("Caller: ", msg.caller, ". Iint with owner list: ", list, "M=", M, "N=", N));

        M
    };

};
