<template>
  <main class="page orders-page">
    <section class="lux-container head">
      <p class="eyebrow">订单</p>
      <h1 class="display-title">订单像时间线一样清晰。</h1>
    </section>

    <section class="lux-container content">
      <div v-if="orders.length" class="orders">
        <article v-for="order in orders" :key="order.id" class="order panel">
          <div class="order__main">
            <span>订单 {{ order.id }}</span>
            <h2>{{ money(order.totalAmount) }}</h2>
            <p>{{ order.createdTime || '刚刚创建' }}</p>
          </div>
          <div class="order__status">
            <i :class="`dot dot--${order.status || 0}`" />
            <strong>{{ statusText[order.status] || '处理中' }}</strong>
          </div>
        </article>
      </div>
      <EmptyState v-else title="暂无订单" text="完成结算后，你的购买记录会出现在这里。">
        <LuxuryButton to="/products">开始选购</LuxuryButton>
      </EmptyState>

      <el-pagination
        v-if="page.total > 10"
        v-model:current-page="pageNum"
        :page-size="10"
        :total="page.total"
        layout="prev, pager, next"
        @current-change="load"
      />
    </section>
  </main>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import { getOrders } from '@/api/order'
import EmptyState from '@/components/ui/EmptyState.vue'
import LuxuryButton from '@/components/ui/LuxuryButton.vue'
import { money } from '@/utils/format'

const page = ref({})
const pageNum = ref(1)
const orders = computed(() => page.value.records || [])
const statusText = ['待付款', '已付款', '已发货', '已完成', '已取消']

async function load() {
  page.value = await getOrders(pageNum.value)
}

onMounted(load)
</script>

<style scoped>
.head {
  display: grid;
  max-width: 920px;
  gap: 22px;
  padding: 12vh 0 48px;
}

.content {
  display: grid;
  gap: 28px;
  padding-bottom: 110px;
}

.orders {
  display: grid;
  gap: 16px;
}

.order {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 24px;
  padding: 28px;
}

.order__main span {
  color: #777;
  font-size: 12px;
  font-weight: 900;
  letter-spacing: 0.14em;
}

.order__main h2 {
  margin: 10px 0;
  font-size: clamp(34px, 4vw, 56px);
}

.order__main p {
  margin: 0;
  color: #888;
}

.order__status {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  border: 1px solid rgba(255, 255, 255, 0.12);
  border-radius: 999px;
  padding: 12px 16px;
}

.dot {
  width: 9px;
  height: 9px;
  border-radius: 50%;
  background: #fff;
  box-shadow: 0 0 16px rgba(255, 255, 255, 0.7);
}

.dot--4 {
  background: #666;
  box-shadow: none;
}

@media (max-width: 680px) {
  .order {
    display: grid;
  }
}
</style>
