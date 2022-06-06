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
import Cycles "mo:base/ExperimentalCycles";
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
    var proposals : Buffer.Buffer<Proposal> = Buffer.Buffer<Proposal>(0);
    var ownedCanisters : [Canister] = [];
    // 对指定canister进行限权
    var canisterPermissions : HashMap.HashMap<Canister, Bool> = HashMap.HashMap<Canister, Bool>(0, func(x: Canister,y: Canister) {x==y}, Principal.hash);

    // 发起提案
    public shared (msg) func propose(ptype: ProposalType,  canister_id: ?Canister, wasm_code: ?Blob, desc: Text) : async Proposal {
        // caller should be one of the owners
        assert(owner_check(msg.caller));

        //  只有 (permission = false) 可以添加权限的容器
        if (ptype == #addPermission) {
            assert(canisterPermissions.get(Option.unwrap(canister_id)) == ?false);
        };

        // 只有 (permission = true) 可以删除权限的容器
        if (ptype == #removePermission) {
            assert(canisterPermissions.get(Option.unwrap(canister_id)) == ?true);
        };

        if (ptype == #installCode) {
            assert(Option.isSome(wasm_code));
        };

        if (ptype == #upgradeCode) {
            assert(Option.isSome(wasm_code));
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
        proposal;
    };

    // 对提案进行投票
    public shared (msg) func vote(id: ID) : async Proposal {
        // 消息调用者是否属于小组成员
        assert(owner_check(msg.caller));

        // 提案id是否合法
        assert(id + 1 <= proposals.size());

        // 获取提案
        var proposal = proposals.get(id);

        // 提案是否完成
        assert(not proposal.finished);

        // 消息调用者是否已对该提案投过票
        assert(Option.isNull(Array.find(proposal.approvers, func(a: Owner) : Bool { a == msg.caller})));

        proposal := Types.add_approver(proposal, msg.caller);

        if (proposal.approvers.size() == M or is_canister_ops_need_no_permission(proposal)) { // meet the threashhold and do the operation
            let ic : IC.Self = actor("aaaaa-aa");

            switch (proposal.ptype) {
                // 限制权限
                case (#addPermission) {
                    canisterPermissions.put(Option.unwrap(proposal.canisterId), true);
                };
                // 解除限权
                case (#removePermission) {
                    canisterPermissions.put(Option.unwrap(proposal.canisterId), false);
                };

                case (#createCanister) {
                    let settings : IC.canister_settings =  {
                        freezing_threshold = null;
                        controllers = ?[Principal.fromActor(self)];
                        memory_allocation = null;
                        compute_allocation = null;
                    };

                    Cycles.add(1_000_000_000_000);
                    let result = await ic.create_canister({settings = ?settings});
                    let canister_id = result.canister_id;
                    ownedCanisters := Array.append(ownedCanisters, [canister_id]);
                    canisterPermissions.put(canister_id, true);
                    proposal := Types.update_canister_id(proposal, canister_id);
                };
                case (#installCode) {
                    let canister_id = Option.unwrap(proposal.canisterId);

                    Cycles.add(1_000_000_000_000);
                    await ic.install_code({
                        arg = [];
                        wasm_module = Blob.toArray(Option.unwrap(proposal.wasm_code));
                        mode = #install;
                        canister_id;
                    });
                };
                case (#upgradeCode) {
                    let canister_id = Option.unwrap(proposal.canisterId);

                    Cycles.add(1_000_000_000_000);
                    await ic.install_code({
                        arg = [];
                        wasm_module = Blob.toArray(Option.unwrap(proposal.wasm_code));
                        mode = #upgrade;
                        canister_id;
                    });
                };
                case (#uninstallCode) {
                    let canister_id = Option.unwrap(proposal.canisterId);

                    Cycles.add(1_000_000_000_000);
                    await ic.uninstall_code({
                        canister_id;
                    });
                };
                case (#startCanister) {
                    let canister_id = Option.unwrap(proposal.canisterId);

                    Cycles.add(1_000_000_000_000);
                    await ic.start_canister({
                        canister_id;
                    });
                };
                case (#stopCanister) {
                    let canister_id = Option.unwrap(proposal.canisterId);

                    Cycles.add(1_000_000_000_000);
                    await ic.stop_canister({
                        canister_id;
                    });
                };
                case (#deleteCanister) {
                    let canister_id = Option.unwrap(proposal.canisterId);

                    Cycles.add(1_000_000_000_000);
                    await ic.delete_canister({
                        canister_id;
                    });
                };
            };

            proposal := Types.finish_proposer(proposal);
        }; 

        Debug.print(debug_show(msg.caller, "APPROVED", proposal.ptype, "Proposal ID", proposal.id, "Executed", proposal.finished));
        Debug.print(debug_show());

        proposals.put(id, proposal);
        proposals.get(id)
    };

    // 拒绝提案
    public shared (msg) func refuse(id: ID) : async Proposal {

        assert(owner_check(msg.caller));

        assert(id + 1 <= proposals.size());

        var proposal = proposals.get(id);

        assert(not proposal.finished);

        assert(Option.isNull(Array.find(proposal.refusers, func(a: Owner) : Bool { a == msg.caller})));

        proposal := Types.add_refuser(proposal, msg.caller);

        if (proposal.refusers.size() + M > N or is_canister_ops_need_no_permission(proposal)) {
            proposal := Types.finish_proposer(proposal);
        };

        Debug.print(debug_show(msg.caller, "REFUSED", proposal.ptype, "Proposal ID", proposal.id, "Executed", proposal.finished));
        Debug.print(debug_show());

        proposals.put(id, proposal);
        proposals.get(id)
    };

    
    // 除了限权、解除限权、创建canister之外的权限判断
    func is_canister_ops_need_no_permission(p: Proposal) : Bool {
        Option.isSome(p.canisterId) and canisterPermissions.get(Option.unwrap(p.canisterId)) == ?false
        and p.ptype != #addPermission 
        and p.ptype != #removePermission 
        and p.ptype != #createCanister
    };

    func owner_check(owner : Owner) : Bool {
        Option.isSome(Array.find(ownerList, func (a: Owner) : Bool { Principal.equal(a, owner) }))
    };

    func canister_check(canister : Canister) : Bool {
        Option.isSome(Array.find(ownedCanisters, func (a: Canister) : Bool { Principal.equal(a, canister) }))
    };
    
    public query func get_proposals() : async [Proposal] {
        proposals.toArray()
    };

    public query func get_proposal(id: ID) : async ?Proposal {
        proposals.getOpt(id)
    };

    public query func get_owner_list() : async [Owner] {
        ownerList
    };

    public query func get_owned_canisters_list() : async [Canister] {
        ownedCanisters
    };

    public query func get_model() : async (Nat, Nat) {
        (M, N)
    };

    public query func get_permission(id: Canister) : async ?Bool {
        canisterPermissions.get(id)
    };

    public shared query ({caller}) func whoami() : async Principal
    {
       caller
    };

    public shared ({caller}) func getCanister() : async Principal
    {
         Principal.fromActor(self);
    };
};