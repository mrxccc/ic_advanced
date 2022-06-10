<template>
    <el-row>
        <el-col :span="8"><div class="grid-content ep-bg-purple" /></el-col>
        <el-col :span="8"><div class="grid-content ep-bg-purple-light" />
            <el-space :fill="fill" wrap
                    :direction="direction"
                    style="width: 30%;display: table-cell;vertical-align: middle;text-align:center;">
                    <el-card v-for="proposal in proposalList" :key="proposal.id" class="box-card" style="width: 250px">
                        <template #header>
                            <div class="card-header">
                                <span @click="copy(proposal.proposer)" class="card-header-text">提出人：{{proposal.proposer}}</span>
                                <span class="button" text>#{{proposal.id}}</span>
                                <button class="button" @click="vote()">投票</button>
                            </div>
                        </template>
                        <el-descriptions
                            :title="proposal.description"
                            :column="2"
                            :size="size"
                            direction="horizontal"
                            :style="blockMargin" >
                            <el-descriptions-item label="提案类型">{{ProposalType.properties[proposal.ptype].name}}</el-descriptions-item>
                            <el-descriptions-item label="同意票数" :span="2">
                                {{proposal.approvers.length}}
                            </el-descriptions-item>
                            <el-descriptions-item label="提案完成状态">
                                {{proposal.finished?'已完成':'未完成'}}
                            </el-descriptions-item>
                        </el-descriptions>
                    </el-card>
            </el-space>
        </el-col>
        <el-col :span="8"><div class="grid-content ep-bg-purple" /></el-col>
    </el-row>
</template>

<script>

import { ref,toRefs,reactive,onMounted,computed } from 'vue'
import { course05 } from "../../../declarations/course05";
import useClipboard from 'vue-clipboard3'
import { useStore } from 'vuex'
export default {
   setup(){
        const fill = ref(true)
        const loading = reactive({
            proposalsLoading: false,
        });
        const store  = useStore()
        const isLogin = computed(() =>{
                return store.state.isLogin
        })
        const webapp = computed(() =>{
                console.log("store.state.webapp", store.state.webapp)
                return store.state.webapp
        })
        const { toClipboard } = useClipboard()
        const ProposalType = {
            installCode: 1,
            appendOwner: 2,
            removeOwner: 3,
            createCanister: 4,
            startCanister: 5,
            stopCanister: 6,
            deleteCanister: 7,
            properties: {
                1: {name: "installCode", value: 1},
                2: {name: "appendOwner", value: 2},
                3: {name: "removeOwner", value: 3},
                4: {name: "createCanister", value: 4},
                5: {name: "startCanister", value: 5},
                6: {name: "stopCanister", value: 6},
                7: {name: "deleteCanister", value: 7},
            }
        }
        const copy = async (text) => {
            try {
                await toClipboard(text)
                ElMessage({
                    message: 'copyed',
                    type: 'success',
                })
            } catch (e) {
                console.error(e)
            }
        }
        const data = reactive({
            proposalList: [],
        });
        const methods = {
            getProposals() {
                loading.proposalsLoading = true
                course05.get_proposals().then((proposals) => {
                    var proposalList = []
                    for(var proposal of proposals){
                        proposalList.push({
                            id: proposal.id, // 提案id
                            proposer: proposal.proposer.toText(), // 提案发起者
                            ptype: ProposalType[Object.keys(proposal.ptype)[0]], // 提案类型
                            canisterId: proposal.canisterId, // 提案指定的canister_id，如果是installCode或者upgradeCode，为空
                            approvers: proposal.approvers, // 提案同意成员
                            finished: proposal.finished, // 提案完成状态
                            description: proposal.description,// 提案描述
                        })
                    }
                    data.proposalList = proposalList
                    console.log(data.proposalList)
                    loading.proposalsLoading = false
                }).catch((err) => {
                    console.log(err)
                    loading.proposalsLoading = false
                });
            },
            vote(id){
                store.state.webapp.vote(id).then((proposals) => {
                    getProposals()
                }).catch((err) => {
                    console.log(err)
                });
            }
        }
        onMounted(() => {
            methods.getProposals()
        });
        return {fill,...toRefs(data),...toRefs(loading),ProposalType,copy}
   }
}
</script>

<style>
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.text {
  font-size: 14px;
}

.item {
  margin-bottom: 18px;
}

.box-card {
  width: 480px;
}
.card-header-text {
    white-space: nowrap;
    width: 200px;
    /* 文字用省略号代替超出的部分 */
    text-overflow: ellipsis;
    /* 匀速溢出内容，隐藏 */
    overflow: hidden;  
    cursor: pointer
}
.card-header-text:hover{
    color: #79bbff;
}
</style>