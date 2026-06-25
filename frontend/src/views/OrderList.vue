<template>
  <div style="max-width:900px;margin:30px auto;padding:0 20px">
    <h2>我的订单</h2>
    <el-empty v-if="!page.records?.length" description="暂无订单" />
    <el-table v-else :data="page.records">
      <el-table-column prop="id"          label="订单ID" width="100" />
      <el-table-column prop="totalAmount" label="总金额" width="120">
        <template #default="{ row }">¥{{ row.totalAmount }}</template>
      </el-table-column>
      <el-table-column prop="status" label="状态" width="100">
        <template #default="{ row }">
          <el-tag :type="statusType[row.status]">{{ statusText[row.status] }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="createdTime" label="下单时间" />
    </el-table>
    <el-pagination background layout="prev,pager,next" :total="page.total" :page-size="10"
      v-model:current-page="pageNum" @current-change="load"
      style="margin-top:16px;display:flex;justify-content:center" />
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useUserStore } from '@/stores/user'
import { getOrders } from '@/api/order'

const store   = useUserStore()
const page    = ref({})
const pageNum = ref(1)

const statusText = ['待付款','已付款','已发货','已完成','已取消']
const statusType = ['warning','','primary','success','info']

async function load() {
  page.value = await getOrders(store.user.id, pageNum.value)
}
onMounted(load)
</script>
