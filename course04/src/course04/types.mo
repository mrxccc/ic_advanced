import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
module {
	public type Owner = Principal;
	public type Canister = Principal;
	public type  ID = Nat;

	public type Proposal = {
		id: ID; // 提案id
		proposer: Owner; // 提案发起者
		wasm_code:  ?Blob; // 如果是installCode,才有值
		ptype: ProposalType; // 提案类型
		canisterId: ?Canister; // 提案指定的canister_id，如果是installCode或者upgradeCode，为空
		approvers: [Owner]; // 提案同意成员
		refusers: [Owner]; // 提案拒绝成员
		finished: Bool; // 提案完成状态
		description: Text;// 提案描述
	};

	public type ProposalType = {
		#addPermission;
		#removePermission;
		#installCode;
		#upgradeCode;
		#uninstallCode;
		#createCanister;
		#startCanister;
		#stopCanister;
		#deleteCanister;
	};

	public func finish_proposer(p1: Proposal) : Proposal {
		{
			id = p1.id;
			proposer = p1.proposer;
			wasm_code = p1.wasm_code;
			ptype = p1.ptype;
			canisterId = p1.canisterId;
			approvers = p1.approvers;
			refusers = p1.refusers;
			finished = true;
			description = p1.description;
  		}
	};

	public func add_approver(p1: Proposal, approver: Owner) : Proposal {
		{
			id = p1.id;
			proposer = p1.proposer;
			wasm_code = p1.wasm_code;
			ptype = p1.ptype;
			canisterId = p1.canisterId;
			approvers = Array.append(p1.approvers, [approver]);
            refusers = p1.refusers;
			finished = p1.finished;
			description = p1.description;
  		}
	};

	public func add_refuser(p1: Proposal, refuser: Owner) : Proposal {
		{
			id = p1.id;
			proposer = p1.proposer;
			wasm_code = p1.wasm_code;
			ptype = p1.ptype;
			canisterId = p1.canisterId;
			approvers = p1.approvers;
            refusers = Array.append(p1.refusers, [refuser]);
			finished = p1.finished;
			description = p1.description;
  		}
	};

	public func update_canister_id(p1: Proposal, id: Canister) : Proposal {
		{
			id = p1.id;
			proposer = p1.proposer;
			wasm_code = p1.wasm_code;
			ptype = p1.ptype;
			canisterId = ?id;
			approvers = p1.approvers;
			refusers = p1.refusers;
			finished = p1.finished;
			description = p1.description;
		}
	};
}