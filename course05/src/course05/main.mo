import Array "mo:base/Array";
import Error "mo:base/Error";
import Buffer "mo:base/Buffer";
import Debug "mo:base/Debug";
import Blob "mo:base/Blob";
import Nat "mo:base/Nat";
import Option "mo:base/Option";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import HashMap "mo:base/HashMap";
import Hash "mo:base/Hash";
import Cycles "mo:base/ExperimentalCycles";
import Iter "mo:base/Iter";
import IC "./ic";
import Types "./types";

actor class(m: Nat, list: [Types.Owner]) = self {
    public type Owner = Types.Owner;
    public type Canister = Types.Canister;
    public type ID = Types.ID;
    public type Proposal = Types.Proposal;
    public type ProposalType = Types.ProposalType;

    // 小组成员
    var ownerList : [Owner] = list;

    var M : Nat = m;
    var N : Nat = ownerList.size();

    // 提案列表
    var proposals :  HashMap.HashMap<ID, Proposal> =  HashMap.HashMap<ID, Proposal>(0, func(x: ID,y: ID) {x == y}, Hash.hash);
    // canisterId列表
    var ownedCanisters :  HashMap.HashMap<Principal, Canister> =  HashMap.HashMap<Principal, Canister>(0, func(x: Principal,y: Principal) {x == y}, Principal.hash);
    // 对指定canister进行限权
    var canisterPermissions : HashMap.HashMap<Principal, Bool> = HashMap.HashMap<Principal, Bool>(0, func(x: Principal,y: Principal) {x == y}, Principal.hash);

    // 发起提案
    public shared (msg) func propose(ptype: ProposalType,  canister_id: ?Principal, wasm_code: ?Blob, desc: Text) : async Proposal {
        // caller should be one of the owners
        assert(owner_check(msg.caller));

        if (ptype == #installCode) {
            assert(Option.isSome(wasm_code));
        };

        if (ptype != #createCanister) {
            assert(Option.isSome(canister_id));
        };

        let canisterId : Principal = Option.unwrap(canister_id);
        assert(Option.isNull(ownedCanisters.get(canisterId)));

        let proposal : Proposal = {
            id = proposals.size(); // 提案id
            proposer = msg.caller; // 提案发起者
            wasm_code; // 如果是installCode,才有值
            ptype; // 提案类型
            canisterId = canister_id; // 提案指定的canister_id，如果是installCode或者upgradeCode，为空
            approvers = []; // 提案同意成员
            finished = false; // 提案完成状态
            description = desc;// 提案描述
        };

        Debug.print(debug_show(msg.caller, "PROPOSED", proposal.ptype, "Proposal ID", proposal.id));
        Debug.print(debug_show());

        proposals.put(proposals.size(), proposal);
        proposal;
    };

    // 对提案进行投票
    public shared (msg) func vote(id: ID) : async Proposal {
        // 消息调用者是否属于小组成员
        assert(owner_check(msg.caller));

        // 提案id是否存在
        assert(Option.isNull(proposals.get(id)));

        // 获取提案
        var proposal = Option.unwrap(proposals.get(id));

        // 提案是否完成
        assert(not proposal.finished);

        // 消息调用者是否已对该提案投过票
        assert(Option.isNull(Array.find(proposal.approvers, func(a: Owner) : Bool { a == msg.caller})));

        proposal := Types.add_approver(proposal, msg.caller);

        // 投票数是否达到阈值，达到阈值直接执行
        if (proposal.approvers.size() == M) {
            let canisterId = Option.unwrap(proposal.canisterId);
            switch (proposal.ptype) {
                // 限制权限
                case (#addPermission) {
                    canisterPermissions.put(canisterId, false);
                };
                // 解除限权
                case (#removePermission) {
                    canisterPermissions.put(canisterId, true);
                };
                case (#createCanister) {
                    let canister_id = await create_canister();
                    proposal := Types.update_canister_id(proposal, canister_id);
                };
                case (#installCode) {
                    await install_code(canisterId, Option.unwrap(proposal.wasm_code));
                };
                case (#startCanister) {
                    await start_canister(canisterId);
                };
                case (#stopCanister) {
                    await stop_canister(canisterId);
                };
                case (#deleteCanister) {
                    await delete_canister(canisterId);
                };
                case (#removeOwner) {
                    appendOwner(canisterId);
                };
                case (#appendOwner) {
                    removeOwner(canisterId);
                };
            };

            proposal := Types.finish_proposer(proposal);
        }; 

        Debug.print(debug_show(msg.caller, "APPROVED", proposal.ptype, "Proposal ID", proposal.id, "Executed", proposal.finished));
        Debug.print(debug_show());

        proposals.put(id, proposal);
        proposal
    };

    // 创建canister
    func create_canister() : async IC.canister_id{
        let ic : IC.Self = actor("aaaaa-aa");
        let settings : IC.canister_settings =  {
            freezing_threshold = null;
            controllers = ?[Principal.fromActor(self)];
            memory_allocation = null;
            compute_allocation = null;
        };

        Cycles.add(1_000_000_000_000);
        let result = await ic.create_canister({settings = ?settings});
        let canister : Canister = {
            id = result.canister_id;
            status = #stopped;
        };
        ownedCanisters.put(result.canister_id, canister);
        canisterPermissions.put(result.canister_id, true);
        return result.canister_id;
    };

    public shared (msg) func createCanister() : async IC.canister_id {
        // caller should be one of the owners
        assert(owner_check(msg.caller));
        await create_canister();
    };

    // 删除canister
    func delete_canister(canister_id : Principal) : async () {
        let ic : IC.Self = actor("aaaaa-aa");
        Cycles.add(1_000_000_000_000);
        await ic.delete_canister({
            canister_id;
        });
        ownedCanisters.delete(canister_id);
    };

    public shared (msg) func deleteCanister(canister_id : Principal) : async () {
        // caller should be one of the owners
        assert(owner_check(msg.caller));
        assert(Option.isSome(canister_check(canister_id)));
        assert(canisterPermissions.get(canister_id) == ?false);
        await delete_canister(canister_id);
    };

    // install code
    func install_code(canisterId : Principal, wasm_code: Blob) : async () {
        Cycles.add(1_000_000_000_000);
        let ic : IC.Self = actor("aaaaa-aa");
        await ic.install_code({
            arg = [];
            wasm_module = Blob.toArray(wasm_code);
            mode = #install;
            canister_id = canisterId;
        });
    };
    public shared (msg) func installCode(canister_id : Principal, wasm_code: Blob) : async () {
        // caller should be one of the owners
        assert(owner_check(msg.caller));
        assert(Option.isSome(canister_check(canister_id)));
        assert(canisterPermissions.get(canister_id) == ?false);
        await install_code(canister_id, wasm_code);
    };

    
    // 停止canister
    func stop_canister(canister_id : Principal) : async (){
        let ic : IC.Self = actor("aaaaa-aa");
        Cycles.add(1_000_000_000_000);
        await ic.stop_canister({
            canister_id;
        });
    };
    public shared (msg) func stopCanister(canister_id : Principal) : async () {
        // caller should be one of the owners
        assert(owner_check(msg.caller));
        assert(Option.isSome(canister_check(canister_id)));
        assert(canisterPermissions.get(canister_id) == ?false);
        await stop_canister(canister_id);
    };


    // 开始canister
    func start_canister(canister_id : Principal) : async (){
        let ic : IC.Self = actor("aaaaa-aa");
        Cycles.add(1_000_000_000_000);
        await ic.start_canister({
            canister_id;
        });
    };
    public shared (msg) func startCanister(canister_id : Principal) : async () {
        // caller should be one of the owners
        assert(owner_check(msg.caller));
        assert(Option.isSome(canister_check(canister_id)));
        assert(canisterPermissions.get(canister_id) == ?false);
        await start_canister(canister_id);
    };


    func owner_check(owner : Owner) : Bool {
        Option.isSome(Array.find(ownerList, func (a: Owner) : Bool { Principal.equal(a, owner) }))
    };

    func canister_check(canister : Principal) : ?Canister {
        ownedCanisters.get(canister)
    };
    
    public query func get_proposals() : async [Proposal] {
        Iter.toArray<Proposal>(proposals.vals());
    };

    public query func get_proposal(id: ID) : async ?Proposal {
        proposals.get(id)
    };

    public query func get_owner_list() : async [Owner] {
        ownerList
    };

    public query func get_owned_canisters_list() : async [Canister] {
        Iter.toArray<Canister>(ownedCanisters.vals());
    };

    public query func get_model() : async (Nat, Nat) {
        (M, N)
    };

    public query func get_permission(canister_id: Principal) : async Bool {
        canisterPermissions.get(canister_id) == ?false
    };

    public shared query ({caller}) func whoami() : async Principal {
        caller
    };

    public shared ({caller}) func getCanister() : async Principal {
        Principal.fromActor(self);
    };

    func removeOwner(owner : Owner) : () {
        ownerList := Array.filter<Principal>(ownerList, func (v) {not Principal.equal(v, owner)});
        N := ownerList.size();
    };

    func appendOwner(owner : Owner) : () {
        ownerList := Array.append(ownerList, [owner]);
        N := ownerList.size();
    };

    public shared query func greet(name : Text) : async Text {
        return "Hello, " # name # "!";
    };
};