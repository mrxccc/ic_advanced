<template>
    <el-row>
        <el-col :span="8"><div class="grid-content ep-bg-purple" /></el-col>
        <el-col :span="8"><div class="grid-content ep-bg-purple-light" />
            <el-space :fill="fill" wrap
                    :direction="direction"
                    style="width: 30%;display: table-cell;vertical-align: middle;text-align:center;">
                    <el-card v-for="i in 2" :key="i" class="box-card" style="width: 250px">
                    <template #header>
                        <div class="card-header">
                        <span>Card name</span>
                        <el-button class="button" text>Operation button</el-button>
                        </div>
                    </template>
                    <div v-for="o in 4" :key="o" class="text item">
                        {{ 'List item ' + o }}
                    </div>
                    </el-card>
            </el-space>
        </el-col>
        <el-col :span="8"><div class="grid-content ep-bg-purple" /></el-col>
    </el-row>
</template>

<script>

import { ref } from 'vue'
export default {
   setup(){
       const fill = ref(true)
       return {fill}
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