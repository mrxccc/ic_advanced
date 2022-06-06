<template>
    <div>
        <a-tabs v-model:activeKey="activeKey" :style="{ background: '#85b4b6c2', padding: '24px'}"  @change="changeTabs">
            <a-tab-pane key="1" tab="提案列表">
                <a-button type="primary" @click="getProposals" :loading="proposalsLoading" style="margin: 10px">刷新</a-button>
                <a-button type="primary" @click="newProposals" :loading="canistersLoading" style="margin: 10px">新增提案</a-button>
                <a-table :columns="proposalsColumns" :data-source="data.proposalData" bordered class="ant-table-striped"></a-table>
            </a-tab-pane>
            <a-tab-pane key="2" tab="canister列表">
                <a-button type="primary" @click="getCanisters" :loading="canistersLoading" style="margin: 10px">刷新</a-button>
                <a-table :columns="canistersColumns" :data-source="data.canisterData" bordered class="ant-table-striped"></a-table>
            </a-tab-pane>
            <a-tab-pane key="3" tab="小组成员" force-render>
                <a-button type="primary" @click="getOwnerList" :loading="ownersLoading" style="margin: 10px">刷新</a-button>
                <a-table :columns="ownersColumns" :data-source="data.ownerData" bordered class="ant-table-striped"></a-table>
            </a-tab-pane>
            <template #rightExtra>
                <a-button @click="login" type="primary" class="tabs-extra-demo-button">登录</a-button>
            </template>
        </a-tabs>
    </div>
</template>

<script>
import { course04 } from "../../declarations/course04";
import { onMounted,reactive,ref  } from "vue";
import { Principal } from "@dfinity/principal";
import { AuthClient } from "@dfinity/auth-client";

export default {
    setup () {
        const authClient = AuthClient.create();
        const canistersLoading = ref(false);
        const ownersLoading = ref(false);
        const proposalsLoading = ref(false);
        const myPrincipal = ref('')
        const canistersColumns = [
          {
            title: 'canisterId',
            dataIndex: 'canisterId',
            key: 'canisterId',
          },
          {
            title: '当前状态',
            dataIndex: 'status',
            key: 'status',
          }
        ];
        const ownersColumns = [
            {
                title: 'canisterId',
                dataIndex: 'canisterId',
                key: 'canisterId',
            }
        ];
        const proposalsColumns = [
          {
            title: 'id',
            dataIndex: 'proposalId',
            key: 'proposalId',
          },
          {
            title: '发起者',
            dataIndex: 'proposer',
            key: 'proposer',
          },
          {
            title: '类型',
            dataIndex: 'ptype',
            key: 'ptype',
          },
          {
            title: '状态',
            dataIndex: 'status',
            key: 'status',
          },
          {
            title: '描述',
            dataIndex: 'description',
            key: 'description',
          },
        ];
        const activeKey =  ref('1')
        const data = reactive({
            canisterData: [],
            ownerData: [],
            proposalData: [],
        });
        const methods = {
            fetchUserInfo(){
                console.log("查询用户信息")
            },
            getCanisters() {
                canistersLoading.value = true
                course04.get_owned_canisters_list().then((canisters) => {
                    console.log(canisters)
                    var canistersList = []
                    var keyIndex = 1
                    for (const canister of canisters) {
                        canistersList.push({key: keyIndex++, canisterId: canister.toText(), status: '投票中',})
                    }
                    data.canisterData = canistersList
                    canistersLoading.value = false
                }).catch((err) => {
                    console.log(err)
                    canistersLoading.value = false
                });
            },
            getOwnerList() {
                ownersLoading.value = true
                course04.get_owner_list().then((owners) => {
                    console.log("aaaa", owners);
                    var ownerList = []
                    var keyIndex = 1
                    for (const owner of owners) {
                        ownerList.push({key: keyIndex++, canisterId: owner.toText()})
                    }
                    console.log("bbb", ownerList)
                    data.ownerData = ownerList
                    ownersLoading.value = false
                }).catch((err) => {
                    console.log(err)
                    ownersLoading.value = false
                });
            },
            getProposals() {
                proposalsLoading.value = true
                course04.get_proposals().then((proposals) => {
                    console.log(proposals);
                    proposalsLoading.value = false
                }).catch((err) => {
                    console.log(err)
                    proposalsLoading.value = false
                });
            },
            login() {
                authClient.login({
                    identityProvider: "https://identity.ic0.app/",
                    onSuccess: () => {
                        const identity = authClient.getIdentity()
                        myPrincipal = identity.getPrincipal().toText()
                    }
                });
            },
            // 新增提案
            newProposals(){

            },
            changeTabs(key){
                switch (key) {
                    case '1':
                        methods.getProposals()
                        break;
                    case '2':
                        methods.getCanisters()
                        break;
                    case '3':
                        methods.getOwnerList()
                        break;
                }
            }
        };
        onMounted(() => {
            // 初始化canisters
            methods.getCanisters()
        });
        return {
            ...methods,data,canistersLoading,ownersLoading,proposalsLoading,canistersColumns,ownersColumns,proposalsColumns,activeKey
        }
    }
}
</script>

<style>
.tabs-extra-demo-button {
  margin-right: 16px;
}
</style>