import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
module {
	public type Owner = Principal;
	public type CanisterStatus = { #stopped; #stopping; #running };
	public type Canister = {
		id: Principal;
		status: CanisterStatus;
	};
	public type ID = Nat;

	public type Proposal = {
		id: ID; // 提案id
		proposer: Owner; // 提案发起者
		wasm_code:  ?Blob; // 如果是installCode,才有值
		ptype: ProposalType; // 提案类型
		canisterId: ?Principal; // 提案指定的canister_id，如果是installCode或者upgradeCode，为空
		approvers: [Owner]; // 提案同意成员
		finished: Bool; // 提案完成状态
		description: Text;// 提案描述
	};

	public type ProposalType = {
		#addPermission;
		#removePermission;
		#installCode;
		#createCanister;
		#startCanister;
		#stopCanister;
		#deleteCanister;
		#removeOwner;
		#appendOwner;
	};

	public func finish_proposer(p1: Proposal) : Proposal {
		{
			id = p1.id;
			proposer = p1.proposer;
			wasm_code = p1.wasm_code;
			ptype = p1.ptype;
			canisterId = p1.canisterId;
			approvers = p1.approvers;
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
			finished = p1.finished;
			description = p1.description;
  		}
	};

	public func add_refuser(p1: Proposal) : Proposal {
		{
			id = p1.id;
			proposer = p1.proposer;
			wasm_code = p1.wasm_code;
			ptype = p1.ptype;
			canisterId = p1.canisterId;
			approvers = p1.approvers;
			finished = p1.finished;
			description = p1.description;
  		}
	};

	public func update_canister_id(p1: Proposal, id: Principal) : Proposal {
		{
			id = p1.id;
			proposer = p1.proposer;
			wasm_code = p1.wasm_code;
			ptype = p1.ptype;
			canisterId = ?id;
			approvers = p1.approvers;
			finished = p1.finished;
			description = p1.description;
		}
	};
}