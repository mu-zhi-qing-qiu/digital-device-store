<template>
  <div>
    <el-table :data="list" border>
      <el-table-column prop="id"          label="订单ID" width="100" />
      <el-table-column prop="userId"      label="用户ID" width="100" />
      <el-table-column prop="totalAmount" label="总金额"  width="120">
        <template #default="{row}">¥{{ row.totalAmount }}</template>
      </el-table-column>
      <el-table-column prop="status" label="状态" width="120">
        <template #default="{ row }">
          <el-select :model-value="row.status" size="small" @change="v => changeStatus(row, v)">
            <el-option v-for="(t,i) in statusText" :key="i" :label="t" :value="i" />
          </el-select>
        </template>
      </el-table-column>
      <el-table-column prop="createdTime" label="下单时间" />
    </el-table>
    <el-pagination background layout="prev,pager,next" :total="total" :page-size="pageSize"
      v-model:current-page="pageNum" @current-change="load" style="margin-top:12px" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getOrders, updateStatus } from '@/api/order'
import { ElMessage } from 'element-plus'

// 管理端查所有用户订单：这里传userId=0查全量，需后端配合；简化版先复用接口
// 生产环境需单独添加 GET /api/order/all 管理员接口
const list      = ref([])
const total     = ref(0)
const pageNum   = ref(1)
const pageSize  = ref(10)
const statusText = ['待付款','已付款','已发货','已完成','已取消']

async function load() {
  // TODO: 后端补全 /api/order/admin/all 接口后替换
  // 暂时展示演示数据
  list.value = []
  total.value = 0
}

async function changeStatus(row, status) {
  await updateStatus({ id: row.id, status })
  row.status = status
  ElMessage.success('状态已更新')
}

onMounted(load)
</script>
