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
                                <span>{{proposal.proposer}}</span>
                                <el-button class="button" text>操作</el-button>
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
                            <el-descriptions-item label="拒绝票数">
                                {{proposal.refusers.length}}
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

import { ref,toRefs,reactive } from 'vue'
export default {
   setup(){
        const fill = ref(true)
        const loading = reactive({
            proposalsLoading: false,
        });
        const ProposalType = {
            installCode: 1,
            upgradeCode: 2,
            uninstallCode: 3,
            createCanister: 4,
            startCanister: 5,
            stopCanister: 6,
            deleteCanister: 7,
            properties: {
                1: {name: "installCode", value: 1},
                2: {name: "upgradeCode", value: 2},
                3: {name: "uninstallCode", value: 3},
                4: {name: "createCanister", value: 4},
                5: {name: "startCanister", value: 5},
                6: {name: "stopCanister", value: 6},
                7: {name: "deleteCanister", value: 7},
            }
        }
        const data = reactive({
            proposalList: [
                {
                    id: 1, // 提案id
                    proposer: "abc", // 提案发起者
                    ptype: 1, // 提案类型
                    canisterId: "abc", // 提案指定的canister_id，如果是installCode或者upgradeCode，为空
                    approvers: [
                        "abc",
                        "def"
                    ], // 提案同意成员
                    refusers: [
                        "abc",
                        "def"
                    ], // 提案拒绝成员
                    finished: true, // 提案完成状态
                    description: "创建canister",// 提案描述
                }
            ],
        });
        const methods = {
            getProposals() {
                loading.proposalsLoading.value = true
                course04.get_proposals().then((proposals) => {
                    console.log(proposals);
                    loading.proposalsLoading.value = false
                }).catch((err) => {
                    console.log(err)
                    loading.proposalsLoading.value = false
                });
            },
        }
        return {fill,...toRefs(data),...toRefs(loading),ProposalType}
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
</style>