<template>
  <section class="admin-page">
    <div class="head">
      <p class="eyebrow">管理端 / 订单</p>
      <h1>订单管理</h1>
    </div>

    <div class="orders">
      <article v-for="item in list" :key="item.id" class="order panel">
        <div>
          <span>订单 {{ item.id }}</span>
          <h2>{{ money(item.totalAmount) }}</h2>
          <p>{{ item.createdTime }}</p>
        </div>
        <select :value="item.status" class="lux-select" @change="changeStatus(item, Number($event.target.value))">
          <option v-for="(label, index) in statusText" :key="label" :value="index">{{ label }}</option>
        </select>
      </article>
    </div>

    <el-pagination
      v-if="total > pageSize"
      v-model:current-page="pageNum"
      :total="total"
      :page-size="pageSize"
      layout="prev, pager, next"
      @current-change="load"
    />
  </section>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getAdminOrders, updateStatus } from '@/api/order'
import { ElMessage } from 'element-plus'
import { money } from '@/utils/format'

const list = ref([])
const total = ref(0)
const pageNum = ref(1)
const pageSize = ref(10)
const statusText = ['待付款', '已付款', '已发货', '已完成', '已取消']

async function load() {
  const page = await getAdminOrders(pageNum.value, pageSize.value)
  list.value = page.records || []
  total.value = page.total || 0
}

async function changeStatus(row, status) {
  await updateStatus({ id: row.id, status })
  row.status = status
  ElMessage.success('状态已更新')
}

onMounted(load)
</script>

<style scoped>
.admin-page {
  display: grid;
  gap: 24px;
}

h1 {
  margin: 8px 0 0;
  font-size: 52px;
}

.orders {
  display: grid;
  gap: 16px;
}

.order {
  display: grid;
  grid-template-columns: 1fr 220px;
  align-items: center;
  gap: 20px;
  padding: 24px;
}

.order span,
.order p {
  margin: 0;
  color: #777;
}

.order h2 {
  margin: 10px 0;
  font-size: 40px;
}

@media (max-width: 760px) {
  .order {
    grid-template-columns: 1fr;
  }
}
</style>
