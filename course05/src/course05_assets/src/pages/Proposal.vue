<template>
    <el-row>
        <el-col :span="8"><div class="grid-content ep-bg-purple" />        
            <el-button size="small" @click="createFormVisible = true">创建提案</el-button></el-col>
        <el-col :span="8"><div class="grid-content ep-bg-purple-light" />
            <el-space :fill="fill" wrap
                    :direction="direction"
                    style="width: 30%;display: table-cell;vertical-align: middle;text-align:center;">
                    <el-card v-for="proposal in proposalList" :key="proposal.id" class="box-card" style="width: 250px">
                        <template #header>
                            <div class="card-header">
                                <span @click="copy(proposal.proposer)" class="card-header-text">提出人：{{proposal.proposer}}</span>
                                <span class="button" text>#{{proposal.id}}</span>
                                <button class="button" @click="vote(proposal.id)">投票</button>
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
    <el-dialog v-model="createFormVisible" title="Warning" width="50%" center>
        <el-form
            ref="ruleFormRef"
            :model="proposalForm"
            status-icon
            :rules="rules"
            label-width="120px"
            class="demo-ruleForm" >
            <el-form-item label="提案类型">
                <el-select v-model="proposalForm.type" placeholder="提案类型">
                    <el-option label="创建canister" value="createCanister" />
                    <el-option label="启动canister" value="startCanister" />
                    <el-option label="停止canister" value="stopCanister" />
                    <el-option label="删除canister" value="removeCanister" />
                    <el-option label="安装代码" value="installCode" />
                    <el-option label="添加限权" value="addPermission" />
                    <el-option label="移除权限" value="removePermission" />
                    <el-option label="添加小组成员" value="appendOwner" />
                    <el-option label="移除小组成员" value="removeOwner" />
                </el-select>
            </el-form-item>
            <el-form-item label="principalId">
                <el-input v-model="proposalForm.principalId" placeholder="principalId" />
            </el-form-item>
            <el-form-item label="wasm_code">
                <el-upload
                    ref="upload"
                    class="upload-demo"
                    :limit="1"
                    :on-exceed="handleExceed"
                    @on-change="fileUpload"
                    :auto-upload="false">
                    <template #trigger>
                    <el-button type="primary">select file</el-button>
                    </template>
                </el-upload>
            </el-form-item>
            <el-form-item label="wasm_code">
                <el-input label="wasm_code" v-model="proposalForm.contentFile" placeholder="wasm_code" />
            </el-form-item>
            <el-form-item label="描述">
                <el-input v-model="proposalForm.desc" placeholder="描述" />
            </el-form-item>
            <el-form-item>
                <el-button type="primary" @click="createProposalForm()">Create</el-button>
                <el-button @click="resetForm()">Reset</el-button>
            </el-form-item>
        </el-form>
      </el-dialog>
</template>

<script>

import { ref,toRefs,reactive,onMounted,computed } from 'vue'
import { course05 } from "../../../declarations/course05";
import useClipboard from 'vue-clipboard3'
import { useStore } from 'vuex'
import { Principal } from "@dfinity/principal";
export default {
   setup(){
        const fill = ref(true)
        const loading = reactive({
            proposalsLoading: false,
        });
        const store  = useStore()
        const { toClipboard } = useClipboard()
        const ProposalType = {
            createCanister: 1,
            startCanister: 2,
            stopCanister: 3,
            removeCanister: 4,
            installCode: 5,
            addPermission: 6,
            removePermission: 7,
            appendOwner: 8,
            removeOwner: 9,
            properties: {
                1: {name: "创建canister", value: 1},
                2: {name: "启动canister", value: 2},
                3: {name: "停止canister", value: 3},
                4: {name: "删除canister", value: 4},
                5: {name: "安装代码", value: 5},
                6: {name: "添加限权", value: 6},
                7: {name: "移除权限", value: 7},
                8: {name: "添加小组成员", value: 8},
                9: {name: "移除小组成员", value: 9},
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
            createFormVisible: false,
            proposalForm: {
                type: "createCanister",
                principalId: null,
                content: [],
                desc: "",
                contentFile: ""
            },
        });
        const rules = reactive({
            type: [
                {
                type: 'array',
                required: true,
                message: 'Please select at least one activity type',
                trigger: 'change',
                },
            ],
            desc: [
                { required: true, message: 'Please input activity form', trigger: 'blur' },
            ],
        })
        const methods = {
            getProposals() {
                loading.proposalsLoading = true
                course05.get_proposals().then((proposals) => {
                    
                    console.log(proposals)
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
                    console.log(proposals)
                    ElMessage({
                        showClose: true,
                        message: '操作成功',
                        type: 'success',
                    })
                    getProposals()
                }).catch((err) => {
                    console.log(err)
                });
            },
            resetForm (){
                data.proposalForm = {
                    type: "createCanister",
                    principalId: null,
                    content: [],
                    desc: "",
                    contentFile: ""
                }
                data.createFormVisible = false
            },
            createProposalForm(){
                var proposalForm = data.proposalForm
                var type = []
                type[proposalForm.type] = null
                var canister_id = proposalForm.principalId
                var content = proposalForm.content
                var desc = proposalForm.desc
                methods.optionProposal(type,canister_id,content, desc)
            },
            optionProposal(type, canister_id, content, disc){
                store.state.webapp.propose(type, canister_id? [Principal.fromText(canister_id)] : [], content? [content] : [], disc)
                .then((proposals) => {
                    ElMessage({
                        showClose: true,
                        message: '操作成功',
                        type: 'success',
                    })
                    getProposals()
                }).catch((err) => {
                    console.log(err)
                    ElMessage.error("操作失败")
                    loading.proposalsLoading = false
                });
            },
            fileUpload(uploadFile, uploadFiles){
                console.log(uploadFile)
            }
        }
        onMounted(() => {
            methods.getProposals()
        });
        return {fill,...toRefs(data),...toRefs(loading),ProposalType,copy,...toRefs(methods),rules}
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