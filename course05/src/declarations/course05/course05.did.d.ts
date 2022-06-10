import type { Principal } from '@dfinity/principal';
export interface Canister { 'id' : Principal, 'status' : CanisterStatus }
export type CanisterStatus = { 'stopped' : null } |
  { 'stopping' : null } |
  { 'running' : null };
export type ID = bigint;
export type ID__1 = bigint;
export type Owner = Principal;
export type Owner__1 = Principal;
export interface Proposal {
  'id' : ID__1,
  'description' : string,
  'finished' : boolean,
  'proposer' : Owner,
  'ptype' : ProposalType,
  'approvers' : Array<Owner>,
  'wasm_code' : [] | [Array<number>],
  'canisterId' : [] | [Principal],
}
export type ProposalType = { 'stopCanister' : null } |
  { 'removeOwner' : null } |
  { 'addPermission' : null } |
  { 'installCode' : null } |
  { 'appendOwner' : null } |
  { 'startCanister' : null } |
  { 'removePermission' : null } |
  { 'createCanister' : null } |
  { 'deleteCanister' : null };
export type ProposalType__1 = { 'stopCanister' : null } |
  { 'removeOwner' : null } |
  { 'addPermission' : null } |
  { 'installCode' : null } |
  { 'appendOwner' : null } |
  { 'startCanister' : null } |
  { 'removePermission' : null } |
  { 'createCanister' : null } |
  { 'deleteCanister' : null };
export interface anon_class_17_1 {
  'createCanister' : () => Promise<canister_id>,
  'deleteCanister' : (arg_0: Principal) => Promise<undefined>,
  'getCanister' : () => Promise<Principal>,
  'get_model' : () => Promise<[bigint, bigint]>,
  'get_owned_canisters_list' : () => Promise<Array<Canister>>,
  'get_owner_list' : () => Promise<Array<Owner__1>>,
  'get_permission' : (arg_0: Principal) => Promise<boolean>,
  'get_proposal' : (arg_0: ID) => Promise<[] | [Proposal]>,
  'get_proposals' : () => Promise<Array<Proposal>>,
  'greet' : (arg_0: string) => Promise<string>,
  'installCode' : (arg_0: Principal, arg_1: Array<number>) => Promise<
      undefined
    >,
  'propose' : (
      arg_0: ProposalType__1,
      arg_1: [] | [Principal],
      arg_2: [] | [Array<number>],
      arg_3: string,
    ) => Promise<Proposal>,
  'startCanister' : (arg_0: Principal) => Promise<undefined>,
  'stopCanister' : (arg_0: Principal) => Promise<undefined>,
  'vote' : (arg_0: ID) => Promise<Proposal>,
  'whoami' : () => Promise<Principal>,
}
export type canister_id = Principal;
export interface _SERVICE extends anon_class_17_1 {}
