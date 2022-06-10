export const idlFactory = ({ IDL }) => {
  const Owner = IDL.Principal;
  const canister_id = IDL.Principal;
  const CanisterStatus = IDL.Variant({
    'stopped' : IDL.Null,
    'stopping' : IDL.Null,
    'running' : IDL.Null,
  });
  const Canister = IDL.Record({
    'id' : IDL.Principal,
    'status' : CanisterStatus,
  });
  const Owner__1 = IDL.Principal;
  const ID = IDL.Nat;
  const ID__1 = IDL.Nat;
  const ProposalType = IDL.Variant({
    'stopCanister' : IDL.Null,
    'removeOwner' : IDL.Null,
    'addPermission' : IDL.Null,
    'installCode' : IDL.Null,
    'appendOwner' : IDL.Null,
    'startCanister' : IDL.Null,
    'removePermission' : IDL.Null,
    'createCanister' : IDL.Null,
    'deleteCanister' : IDL.Null,
  });
  const Proposal = IDL.Record({
    'id' : ID__1,
    'description' : IDL.Text,
    'finished' : IDL.Bool,
    'proposer' : Owner,
    'ptype' : ProposalType,
    'approvers' : IDL.Vec(Owner),
    'wasm_code' : IDL.Opt(IDL.Vec(IDL.Nat8)),
    'canisterId' : IDL.Opt(IDL.Principal),
  });
  const ProposalType__1 = IDL.Variant({
    'stopCanister' : IDL.Null,
    'removeOwner' : IDL.Null,
    'addPermission' : IDL.Null,
    'installCode' : IDL.Null,
    'appendOwner' : IDL.Null,
    'startCanister' : IDL.Null,
    'removePermission' : IDL.Null,
    'createCanister' : IDL.Null,
    'deleteCanister' : IDL.Null,
  });
  const anon_class_17_1 = IDL.Service({
    'createCanister' : IDL.Func([], [canister_id], []),
    'deleteCanister' : IDL.Func([IDL.Principal], [], []),
    'getCanister' : IDL.Func([], [IDL.Principal], []),
    'get_model' : IDL.Func([], [IDL.Nat, IDL.Nat], ['query']),
    'get_owned_canisters_list' : IDL.Func([], [IDL.Vec(Canister)], ['query']),
    'get_owner_list' : IDL.Func([], [IDL.Vec(Owner__1)], ['query']),
    'get_permission' : IDL.Func([IDL.Principal], [IDL.Bool], ['query']),
    'get_proposal' : IDL.Func([ID], [IDL.Opt(Proposal)], ['query']),
    'get_proposals' : IDL.Func([], [IDL.Vec(Proposal)], ['query']),
    'greet' : IDL.Func([IDL.Text], [IDL.Text], ['query']),
    'installCode' : IDL.Func([IDL.Principal, IDL.Vec(IDL.Nat8)], [], []),
    'propose' : IDL.Func(
        [
          ProposalType__1,
          IDL.Opt(IDL.Principal),
          IDL.Opt(IDL.Vec(IDL.Nat8)),
          IDL.Text,
        ],
        [Proposal],
        [],
      ),
    'startCanister' : IDL.Func([IDL.Principal], [], []),
    'stopCanister' : IDL.Func([IDL.Principal], [], []),
    'vote' : IDL.Func([ID], [Proposal], []),
    'whoami' : IDL.Func([], [IDL.Principal], ['query']),
  });
  return anon_class_17_1;
};
export const init = ({ IDL }) => {
  const Owner = IDL.Principal;
  return [IDL.Nat, IDL.Vec(Owner)];
};
