import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Principal "mo:base/Principal";

module {
	public type Owner = Principal;
	public type Canister = Principal;
	public type  ID = Nat;

	public type Proposal = {
		id: ID; // 提案id
		proposer: Owner; // 提案发起者
		ptype: ProposalType; // 提案类型
		canisterId: Canister; // 提案指定的canister_id
		approvers: [Owner]; // 提案同意成员
		finished: Bool; // 提案完成状态
		targetOwner: Owner; // 需要限制权限/加入权限的Owner
	};

	public type ProposalType = {
		#restrictPermissions;
		#accessRestriction;
	};

	public func finish_proposer(p1: Proposal) : Proposal {
		{
			id = p1.id;
			proposer = p1.proposer;
			ptype = p1.ptype;
			canisterId = p1.canisterId;
			approvers = p1.approvers;
			finished = true;
			targetOwner = p1.targetOwner;
  		}
	};

	public func add_approver(p1: Proposal, approver: Owner) : Proposal {
		{
			id = p1.id;
			proposer = p1.proposer;
			ptype = p1.ptype;
			canisterId = p1.canisterId;
			approvers = Array.append(p1.approvers, [approver]);
			finished = p1.finished;
			targetOwner = p1.targetOwner;
  		}
	};

	public func update_canister_id(p1: Proposal, id: Canister) : Proposal {
		{
			id = p1.id;
			proposer = p1.proposer;
			ptype = p1.ptype;
			canisterId = id;
			approvers = p1.approvers;
			finished = p1.finished;
			targetOwner = p1.targetOwner;
		}
	};
}