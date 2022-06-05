<template>
    <div>
        <a-tabs v-model:activeKey="activeKey" :style="{ background: '#85b4b6c2', padding: '24px'}"  @change="changeTabs">
            <a-tab-pane key="1" tab="canister列表">
                <a-button type="primary" @click="getCanisters" :loading="canistersLoading" style="margin: 10px">获取canister列表</a-button>
                <a-table :columns="canistersColumns" :data-source="canisterData" bordered class="ant-table-striped"></a-table>
            </a-tab-pane>
            <a-tab-pane key="2" tab="小组成员" force-render>
                <a-button type="primary" @click="getOwnerList" :loading="ownersLoading" style="margin: 10px">获取小组成员列表</a-button>
                <a-table :columns="canistersColumns" :data-source="canisterData" bordered class="ant-table-striped"></a-table>
            </a-tab-pane>
            <a-tab-pane key="3" tab="当前提案">
                <a-button type="primary" @click="getProposals" :loading="proposalsLoading" style="margin: 10px">获取当前提案列表</a-button>
                <a-table :columns="canistersColumns" :data-source="canisterData" bordered class="ant-table-striped"></a-table>
            </a-tab-pane>
        </a-tabs>
    </div>
</template>

<script>
import { course04 } from "../../declarations/course04";
import { onMounted,reactive,ref  } from "vue";
import { Principal } from "@dfinity/principal";
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
export default {
    setup () {
        const canistersLoading = ref(false);
        const ownersLoading = ref(false);
        const proposalsLoading = ref(false);
        
        const activeKey =  ref('1')
        const data = reactive({
            text: 'abc',
            canistersColumns,
            canisterData: [
                {
                    key: '1',
                    canisterId: 'John Brown',
                    status: '投票中',
                },
                {
                    key: '2',
                    canisterId: 'John Brown',
                    status: '投票中',
                },
            ],
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
                        canistersList.push({key: keyIndex++, canisterId: Principal.toText(canister), status: '投票中',})
                    }
                    data.canisterData = canistersList
                    canistersLoading.value = false
                })
            },
            getOwnerList() {
                ownersLoading.value = true
                course04.get_owner_list().then((owners) => {
                    console.log(owners);
                    ownersLoading.value = false
                })
            },
            getProposals() {
                proposalsLoading.value = true
                course04.get_proposal_list().then((proposals) => {
                    console.log(owners);
                    proposalsLoading.value = false
                })
            },
            changeTabs(key){
                switch (key) {
                    case '1':
                        methods.getCanisters()
                        break;
                
                    case '2':
                        methods.getOwnerList()
                        break;
                    case '3':
                        methods.getProposals()
                        break;
                }
            }
        };
        onMounted(() => {
            // 初始化canisters
            methods.getCanisters()
        });
        return {
            ...methods,data,canistersLoading,ownersLoading,proposalsLoading,activeKey
        }
    }
}
</script>

<style>

</style>