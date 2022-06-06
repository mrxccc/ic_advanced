export const idlFactory = ({ IDL }) => {
  const Owner = IDL.Principal;
  const Canister__1 = IDL.Principal;
  const Owner__1 = IDL.Principal;
  const ID = IDL.Nat;
  const ID__1 = IDL.Nat;
  const ProposalType = IDL.Variant({
    'stopCanister' : IDL.Null,
    'upgradeCode' : IDL.Null,
    'addPermission' : IDL.Null,
    'installCode' : IDL.Null,
    'uninstallCode' : IDL.Null,
    'startCanister' : IDL.Null,
    'removePermission' : IDL.Null,
    'createCanister' : IDL.Null,
    'deleteCanister' : IDL.Null,
  });
  const Canister = IDL.Principal;
  const Proposal = IDL.Record({
    'id' : ID__1,
    'refusers' : IDL.Vec(Owner),
    'description' : IDL.Text,
    'finished' : IDL.Bool,
    'proposer' : Owner,
    'ptype' : ProposalType,
    'approvers' : IDL.Vec(Owner),
    'wasm_code' : IDL.Opt(IDL.Vec(IDL.Nat8)),
    'canisterId' : IDL.Opt(Canister),
  });
  const ProposalType__1 = IDL.Variant({
    'stopCanister' : IDL.Null,
    'upgradeCode' : IDL.Null,
    'addPermission' : IDL.Null,
    'installCode' : IDL.Null,
    'uninstallCode' : IDL.Null,
    'startCanister' : IDL.Null,
    'removePermission' : IDL.Null,
    'createCanister' : IDL.Null,
    'deleteCanister' : IDL.Null,
  });
  const anon_class_15_1 = IDL.Service({
    'getCanister' : IDL.Func([], [IDL.Principal], []),
    'get_model' : IDL.Func([], [IDL.Nat, IDL.Nat], ['query']),
    'get_owned_canisters_list' : IDL.Func(
        [],
        [IDL.Vec(Canister__1)],
        ['query'],
      ),
    'get_owner_list' : IDL.Func([], [IDL.Vec(Owner__1)], ['query']),
    'get_permission' : IDL.Func([Canister__1], [IDL.Opt(IDL.Bool)], ['query']),
    'get_proposal' : IDL.Func([ID], [IDL.Opt(Proposal)], ['query']),
    'get_proposals' : IDL.Func([], [IDL.Vec(Proposal)], ['query']),
    'propose' : IDL.Func(
        [
          ProposalType__1,
          IDL.Opt(Canister__1),
          IDL.Opt(IDL.Vec(IDL.Nat8)),
          IDL.Text,
        ],
        [Proposal],
        [],
      ),
    'refuse' : IDL.Func([ID], [Proposal], []),
    'vote' : IDL.Func([ID], [Proposal], []),
    'whoami' : IDL.Func([], [IDL.Principal], ['query']),
  });
  return anon_class_15_1;
};
export const init = ({ IDL }) => {
  const Owner = IDL.Principal;
  return [IDL.Nat, IDL.Vec(Owner)];
};
