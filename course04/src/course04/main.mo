import Array "mo:base/Array";
import Error "mo:base/Error";
import Buffer "mo:base/Buffer";
import Debug "mo:base/Debug";
import Blob "mo:base/Blob";
import Nat "mo:base/Nat";
import Option "mo:base/Option";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import IC "./ic";
import Types "./types";

actor class() = self {
    public type Owner = Types.Owner;
    public type Canister = Types.Canister;
    public type ID = Types.ID;
    public type Proposal = Types.Proposal;
    public type ProposalType = Types.ProposalType;

    var M : Nat = 0;
    var N : Nat = 0;

    // 提案列表
    var proposals : Buffer.Buffer<Proposal> = Buffer.Buffer<Proposal>(0);
    var ownedCanisters : [Canister] = [];
    // 小组成员
    var ownerList : [Owner] = [];

    public type MyPropose = actor {
        removeOwner : shared(owner : Owner) -> async (); // 移除Owner
        appendOwner : shared(owner : Owner) -> async (); // 添加Owner
        init : shared(list : [Owner], m : Nat) -> async Nat; // 初始化Owner
    };

    // 发起提案
    public shared (msg) func propose(ptype: ProposalType,  canister_id: ?Canister, wasm_code: ?Blob, desc: Text ) : async Proposal {
        // caller should be one of the owners
        assert(owner_check(msg.caller));

        assert(canister_check(canister_id));

        if (ptype == #installCode) {
            assert(Option.isSome(wasm_code));
            wasm_code_hash := SHA256.sha256(Blob.toArray(Option.unwrap(wasm_code)));
        };

        if (ptype == #upgradeCode) {
            assert(Option.isSome(wasm_code));
            wasm_code_hash := SHA256.sha256(Blob.toArray(Option.unwrap(wasm_code)));
        };

        if (ptype != #createCanister) {
            assert(Option.isSome(canister_id));
        };

        switch (canister_id) {
            case (?id) assert(canister_check(id));
            case (null) {};
        };

        let proposal : Proposal = {
            id = proposals.size();
            wasm_code;
			wasm_code_hash;
            ptype;
            proposer = msg.caller;
            canisterId = canister_id;
            approvers = [];
            refusers = [];
            finished = false;
            description= desc;
        };

        Debug.print(debug_show(msg.caller, "PROPOSED", proposal.ptype, "Proposal ID", proposal.id));
        Debug.print(debug_show());

        proposals.add(proposal);

        proposal
    };

    // 对提案进行投票
    public shared (msg) func vote(id: ID) : async Proposal {
        // caller should be one of the owners
        assert(owner_check(msg.caller));

        assert(id + 1 <= proposals.size());

        // 获取提案
        var proposal = proposals.get(id);

        // 提案是否完成
        assert(not proposal.finished);

        // 消息调用者是否属于小组成员
        assert(Option.isNull(Array.find(proposal.approvers, func(a: Owner) : Bool { a == msg.caller})));

        proposal := Types.add_approver(proposal, msg.caller);

        if (proposal.approvers.size() > M/N) { // meet the threashhold and do the operation
            let ic : IC.Self = actor("aaaaa-aa");

            switch (proposal.ptype) {
                // 限制权限：移除指定Owner
                case (#restrictPermissions) {
                    var canister : MyPropose = actor(Principal.toText(proposal.canisterId));
                    await canister.removeOwner(proposal.targetOwner);
                };
                // 解除限权：加入指定Owner
                case (#accessRestriction) {
                    var canister : MyPropose = actor(Principal.toText(proposal.canisterId));
                    await canister.appendOwner(proposal.targetOwner);
                };
            };

            proposal := Types.finish_proposer(proposal);
        }; 

        Debug.print(debug_show(msg.caller, "APPROVED", proposal.ptype, "Proposal ID", proposal.id, "Executed", proposal.finished));
        Debug.print(debug_show());

        proposals.put(id, proposal);
        proposals.get(id)
    };

  
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
        // 初始化ownerList
        var canister : MyPropose = actor(Principal.toText(result.canister_id));
        var res = await canister.init(ownerList, M);
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

    public query func get_proposal_list() : async [Proposal] {
        proposals.toArray()
    };

    public query func get_proposal(id: ID) : async ?Proposal {
        proposals.getOpt(id)
    };

    func owner_check(owner : Owner) : Bool {
        Option.isSome(Array.find(ownerList, func (a: Owner) : Bool { Principal.equal(a, owner) }))
    };

    func canister_check(canister : Canister) : Bool {
        Option.isSome(Array.find(ownedCanisters, func (a: Canister) : Bool { Principal.equal(a, canister) }))
    };

    public query func get_owner_list() : async [Owner] {
        ownerList
    };

    public query func get_owned_canisters_list() : async [Canister] {
        ownedCanisters
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

    public shared (msg) func removeOwner(owner : Owner) : async () {
        assert(owner_check(msg.caller));
        assert(ownerList.size() != 0);
        ownerList := Array.filter<Principal>(ownerList, func (v) {not Principal.equal(v, owner)});
    };

    public shared (msg) func appendOwner(owner : Owner) : async () {
        assert(owner_check(msg.caller));
        ownerList := Array.append(ownerList, [owner]);
    };
};