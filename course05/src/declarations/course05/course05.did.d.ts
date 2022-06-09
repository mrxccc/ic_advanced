import type { Principal } from '@dfinity/principal';
export type Canister = Principal;
export type Canister__1 = Principal;
export type ID = bigint;
export type ID__1 = bigint;
export type Owner = Principal;
export type Owner__1 = Principal;
export interface Proposal {
  'id' : ID__1,
  'refusers' : Array<Owner>,
  'description' : string,
  'finished' : boolean,
  'proposer' : Owner,
  'ptype' : ProposalType,
  'approvers' : Array<Owner>,
  'wasm_code' : [] | [Array<number>],
  'canisterId' : [] | [Canister],
}
export type ProposalType = { 'stopCanister' : null } |
  { 'upgradeCode' : null } |
  { 'addPermission' : null } |
  { 'installCode' : null } |
  { 'uninstallCode' : null } |
  { 'startCanister' : null } |
  { 'removePermission' : null } |
  { 'createCanister' : null } |
  { 'deleteCanister' : null };
export type ProposalType__1 = { 'stopCanister' : null } |
  { 'upgradeCode' : null } |
  { 'addPermission' : null } |
  { 'installCode' : null } |
  { 'uninstallCode' : null } |
  { 'startCanister' : null } |
  { 'removePermission' : null } |
  { 'createCanister' : null } |
  { 'deleteCanister' : null };
export interface anon_class_15_1 {
  'getCanister' : () => Promise<Principal>,
  'get_model' : () => Promise<[bigint, bigint]>,
  'get_owned_canisters_list' : () => Promise<Array<Canister__1>>,
  'get_owner_list' : () => Promise<Array<Owner__1>>,
  'get_permission' : (arg_0: Canister__1) => Promise<[] | [boolean]>,
  'get_proposal' : (arg_0: ID) => Promise<[] | [Proposal]>,
  'get_proposals' : () => Promise<Array<Proposal>>,
  'propose' : (
      arg_0: ProposalType__1,
      arg_1: [] | [Canister__1],
      arg_2: [] | [Array<number>],
      arg_3: string,
    ) => Promise<Proposal>,
  'refuse' : (arg_0: ID) => Promise<Proposal>,
  'vote' : (arg_0: ID) => Promise<Proposal>,
  'whoami' : () => Promise<Principal>,
}
export interface _SERVICE extends anon_class_15_1 {}
