<template>
  <el-row>
      <el-col :span="2"><div class="grid-content ep-bg-purple" /></el-col>
      <el-col :span="20"><div class="grid-content ep-bg-purple-light" />
        <el-table :data="ownerList" style="width: 100%" stripe  >
          <el-table-column prop="principalId" label="principalId"/>
        </el-table>
      </el-col>
      <el-col :span="2"><div class="grid-content ep-bg-purple" /></el-col>
  </el-row>
</template>

<script>

import { ref,toRefs,reactive,onMounted,computed } from 'vue'
import { course05 } from "../../../declarations/course05";
import { useStore } from 'vuex'
export default {
 setup(){
      const fill = ref(true)
      const loading = reactive({
        ownerLoading: false,
      });
      const data = reactive({
        ownerList: [],
      });
      const store  = useStore()
      const isLogin = computed(() =>{
            return store.state.isLogin
      })
      const webapp = computed(() =>{
            return store.state.webapp
      })
      const methods = {
        getOwners() {
          loading.ownerLoading = true
            course05.get_owner_list().then((owners) => {
                console.log(owners)
                var ownerList = []
                var keyIndex = 1
                for (const id of owners) {
                    ownerList.push({principalId: id.toText(),})
                }
                data.ownerList = ownerList
                loading.ownerLoading = false
            }).catch((err) => {
                console.log(err)
                loading.ownerLoading = false
            });
        },
      }
      onMounted(() => {
            methods.getOwners()
      });
      return {fill,...toRefs(data),...toRefs(loading)}
 }
}
</script>

<style>
</style>