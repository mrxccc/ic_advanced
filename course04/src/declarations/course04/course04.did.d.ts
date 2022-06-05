import type { Principal } from '@dfinity/principal';
export type Canister = Principal;
export type Canister__1 = Principal;
export type ID = bigint;
export type ID__1 = bigint;
export type Owner = Principal;
export type Owner__1 = Principal;
export interface Proposal {
  'id' : ID__1,
  'description' : string,
  'finished' : boolean,
  'proposer' : Owner,
  'targetOwner' : Owner,
  'ptype' : ProposalType,
  'approvers' : Array<Owner>,
  'canisterId' : Canister,
}
export type ProposalType = { 'restrictPermissions' : null } |
  { 'accessRestriction' : null };
export type ProposalType__1 = { 'restrictPermissions' : null } |
  { 'accessRestriction' : null };
export interface anon_class_13_1 {
  'appendOwner' : (arg_0: Owner__1) => Promise<undefined>,
  'create_canister' : () => Promise<canister_id>,
  'delete_canister' : (arg_0: Principal) => Promise<undefined>,
  'get_owned_canisters_list' : () => Promise<Array<Canister__1>>,
  'get_owner_list' : () => Promise<Array<Owner__1>>,
  'get_proposal' : (arg_0: ID) => Promise<[] | [Proposal]>,
  'get_proposal_list' : (arg_0: ID) => Promise<Array<Proposal>>,
  'init' : (arg_0: Array<Owner__1>, arg_1: bigint) => Promise<bigint>,
  'install_code' : (arg_0: Principal, arg_1: [] | [Array<number>]) => Promise<
      undefined
    >,
  'propose' : (
      arg_0: ProposalType__1,
      arg_1: Canister__1,
      arg_2: Owner__1,
      arg_3: string,
    ) => Promise<Proposal>,
  'removeOwner' : (arg_0: Owner__1) => Promise<undefined>,
  'start_canister' : (arg_0: Principal) => Promise<undefined>,
  'stop_canister' : (arg_0: Principal) => Promise<undefined>,
  'vote' : (arg_0: ID) => Promise<Proposal>,
}
export type canister_id = Principal;
export interface _SERVICE extends anon_class_13_1 {}
