<template>
  <el-row>
      <el-col :span="8"><div class="grid-content ep-bg-purple" /></el-col>
      <el-col :span="8"><div class="grid-content ep-bg-purple-light" />
        <el-table
          :data="canisterList"
          style="width: 100%"
          :row-class-name="tableRowClassName" >
          <el-table-column prop="canisterId" label="Date" width="180" />
          <el-table-column prop="hasPermission" label="Name" width="180" />
        </el-table>
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
        canisterLoading: false,
      });
      const data = reactive({
        canisterList: [
              {
                  canisterId: "cd7qk-my6ce-anlh6-7wlh5-lw5ry-3ml6o-sjoqg-24cdj-fbryj-7sug2-cqe",
                  hasPermission: true,
              },
              {
                  canisterId: "cd7qk-my6ce-anlh6-7wlh5-lw5ry-3ml6o-sjoqg-24cdj-fbryj-7sug2-cqe",
                  hasPermission: true,
              }
          ],
      });
      const methods = {
        getCanisters() {
          loading.canisterLoading.value = true
            course04.get_owned_canisters_list().then((canisters) => {
                console.log(canisters)
                var canistersList = []
                var keyIndex = 1
                for (const canister of canisters) {
                    canistersList.push({key: keyIndex++, canisterId: canister.toText(), status: '投票中',})
                }
                data.canisterList = canistersList
                loading.canisterLoading.value = false
            }).catch((err) => {
                console.log(err)
                loading.canisterLoading.value = false
            });
        },
      }
      return {fill,...toRefs(data),...toRefs(loading),ProposalType}
 }
}
</script>

<style>
.el-table .warning-row {
  --el-table-tr-bg-color: var(--el-color-warning-light-9);
}
.el-table .success-row {
  --el-table-tr-bg-color: var(--el-color-success-light-9);
} 
</style>