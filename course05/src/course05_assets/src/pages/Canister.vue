<template>
  <el-row>
      <el-col :span="2"><div class="grid-content ep-bg-purple" /></el-col>
      <el-col :span="20"><div class="grid-content ep-bg-purple-light" />
        <el-table :data="canisterList" style="width: 100%" stripe  v-loading="canisterLoading">
          <el-table-column prop="canisterId" label="canisterId"/>
          <el-table-column prop="status" label="状态"/>
          <el-table-column align="right">
          <template #header>
            <el-popconfirm title="确认开启canister?" @confirm="createCanister()">
                <template #reference>
                  <el-button size="small" >创建canister</el-button>
                </template>
              </el-popconfirm>
          </template>
            <template #default="scope">
              <el-popconfirm title="确认开启canister?" @confirm="handleStart(scope.$index, scope.row)">
                <template #reference>
                  <el-button size="small" >开启</el-button>
                </template>
              </el-popconfirm>
              <el-popconfirm title="确认关闭canister?" @click="handleStop(scope.$index, scope.row)">
                <template #reference>
                  <el-button size="small">停止</el-button>
                </template>
              </el-popconfirm>
              <el-popconfirm title="确认删除canister?" @click="handleDelete(scope.$index, scope.row)">
                <template #reference>
                  <el-button size="small">删除</el-button>
                </template>
              </el-popconfirm>
            </template>
          </el-table-column>
        </el-table>
      </el-col>
      <el-col :span="2"><div class="grid-content ep-bg-purple" /></el-col>
  </el-row>
</template>

<script>

import { ref,toRefs,reactive,onMounted,computed } from 'vue'
import { course05 } from "../../../declarations/course05";
import { Principal } from "@dfinity/principal";
import { useStore } from 'vuex'
export default {
 setup(){
      const fill = ref(true)
      const loading = reactive({
        canisterLoading: false,
      });
      
      const Status = {
          stopped: 1,
          stopping: 2,
          running: 3,
          properties: {
              1: {name: "stopped", value: 1},
              2: {name: "stopping", value: 2},
              3: {name: "running", value: 3}
          }
      }
      const store  = useStore()
      const isLogin = computed(() =>{
            return store.state.isLogin
      })
      const webapp = computed(() =>{
            console.log(store.state.webapp)
            return store.state.webapp.CanisterActor
      })
      const data = reactive({
        canisterList: [],
      });
      const methods = {
        getCanisters() {
          loading.canisterLoading = true
            course05.get_owned_canisters_list().then((canisters) => {
                console.log(canisters)
                var canistersList = []
                var keyIndex = 1
                for (const canister of canisters) {
                    canistersList.push({canisterId: canister.id.toText(), status: Object.keys(canister.status)[0],})
                }
                data.canisterList = canistersList
                loading.canisterLoading = false
            }).catch((err) => {
                console.log(err)
                loading.canisterLoading = false
            });
        },
        handleStart(index,row){
          loading.canisterLoading = true
          store.state.webapp.startCanister(Principal.fromText(row.canisterId)).then((canisters) => {
              getCanisters()
          }).catch((err) => {
              console.log(err)
              ElMessage.error("操作失败")
              loading.canisterLoading = false
          });
          loading.canisterLoading = true
        },
        handleStop(index,row){
          loading.canisterLoading = true
          store.state.webapp.stopCanister(Principal.fromText(row.canisterId)).then(() => {
              getCanisters()
          }).catch((err) => {
              console.log(err)
              ElMessage.error("操作失败")
              loading.canisterLoading = false
          });
          loading.canisterLoading = false
        },
        handleDelete(index,row){
          loading.canisterLoading = true
          store.state.webapp.deleteCanister(Principal.fromText(row.canisterId)).then(() => {
              getCanisters()
          }).catch((err) => {
              console.log(err)
              ElMessage.error("操作失败")
              loading.canisterLoading = false
          });
          loading.canisterLoading = false
        },
        createCanister(){
          loading.canisterLoading = true
          console.log(store.state.webapp)
          store.state.webapp.createCanister().then((canisters) => {
              getCanisters()
          }).catch((err) => {
              console.log(err)
              ElMessage.error("操作失败")
              loading.canisterLoading = false
          });
          loading.canisterLoading = false
        },
      }
      onMounted(() => {
          methods.getCanisters()
      });
      return {fill,...toRefs(data),...toRefs(loading),...toRefs(methods)}
 }
}
</script>

<style>
</style>