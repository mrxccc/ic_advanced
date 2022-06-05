export const idlFactory = ({ IDL }) => {
  const Owner__1 = IDL.Principal;
  const canister_id = IDL.Principal;
  const Canister__1 = IDL.Principal;
  const ID = IDL.Nat;
  const ID__1 = IDL.Nat;
  const Owner = IDL.Principal;
  const ProposalType = IDL.Variant({
    'restrictPermissions' : IDL.Null,
    'accessRestriction' : IDL.Null,
  });
  const Canister = IDL.Principal;
  const Proposal = IDL.Record({
    'id' : ID__1,
    'description' : IDL.Text,
    'finished' : IDL.Bool,
    'proposer' : Owner,
    'targetOwner' : Owner,
    'ptype' : ProposalType,
    'approvers' : IDL.Vec(Owner),
    'canisterId' : Canister,
  });
  const ProposalType__1 = IDL.Variant({
    'restrictPermissions' : IDL.Null,
    'accessRestriction' : IDL.Null,
  });
  const anon_class_13_1 = IDL.Service({
    'appendOwner' : IDL.Func([Owner__1], [], []),
    'create_canister' : IDL.Func([], [canister_id], []),
    'delete_canister' : IDL.Func([IDL.Principal], [], []),
    'get_owned_canisters_list' : IDL.Func(
        [],
        [IDL.Vec(Canister__1)],
        ['query'],
      ),
    'get_owner_list' : IDL.Func([], [IDL.Vec(Owner__1)], ['query']),
    'get_proposal' : IDL.Func([ID], [IDL.Opt(Proposal)], ['query']),
    'get_proposal_list' : IDL.Func([ID], [IDL.Vec(Proposal)], ['query']),
    'init' : IDL.Func([IDL.Vec(Owner__1), IDL.Nat], [IDL.Nat], []),
    'install_code' : IDL.Func(
        [IDL.Principal, IDL.Opt(IDL.Vec(IDL.Nat8))],
        [],
        [],
      ),
    'propose' : IDL.Func(
        [ProposalType__1, Canister__1, Owner__1, IDL.Text],
        [Proposal],
        [],
      ),
    'removeOwner' : IDL.Func([Owner__1], [], []),
    'start_canister' : IDL.Func([IDL.Principal], [], []),
    'stop_canister' : IDL.Func([IDL.Principal], [], []),
    'vote' : IDL.Func([ID], [Proposal], []),
  });
  return anon_class_13_1;
};
export const init = ({ IDL }) => { return []; };
