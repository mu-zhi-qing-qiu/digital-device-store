<template>
  <main class="page orders-page">
    <section class="lux-container head">
      <p class="eyebrow">订单</p>
      <h1 class="display-title">订单像时间线一样清晰</h1>
    </section>

    <section class="lux-container content">
      <div v-if="orders.length" class="orders">
        <article v-for="order in orders" :key="order.id" class="order panel">
          <div class="order__main">
            <span>订单 {{ order.id }}</span>
            <h2>{{ money(order.totalAmount) }}</h2>
            <p>{{ order.createdTime || '刚刚创建' }}</p>
          </div>
          <div class="order__side">
            <div class="order__status">
              <i :class="`dot dot--${order.status || 0}`" />
              <strong>{{ statusText[order.status] || '处理中' }}</strong>
            </div>
            <LuxuryButton v-if="order.status === 0" variant="primary" @click="openPay(order)">
              去支付
            </LuxuryButton>
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

    <!-- 支付弹窗 -->
    <Teleport to="body">
      <Transition name="pay-fade">
        <div v-if="payVisible" class="pay-mask" @click.self="closePay">
          <div class="pay-modal panel">
            <header class="pay-modal__head">
              <div>
                <p class="eyebrow">收银台 · 模拟支付</p>
                <h2>订单 {{ activeOrder?.id }}</h2>
              </div>
              <button class="pay-modal__close" aria-label="关闭" @click="closePay">×</button>
            </header>

            <div class="pay-modal__body thin-scrollbar">
              <p v-if="itemsLoading" class="pay-empty">正在加载订单商品…</p>
              <p v-else-if="!payItems.length" class="pay-empty">未获取到订单商品。</p>
              <ul v-else class="pay-items">
                <li v-for="item in payItems" :key="item.id" class="pay-item">
                  <div class="pay-item__media">
                    <img v-if="cover(item)" :src="cover(item)" :alt="item.productName" />
                    <span v-else class="pay-item__ph">{{ (item.productName || '商品').slice(0, 1) }}</span>
                  </div>
                  <div class="pay-item__info">
                    <strong>{{ item.productName || '未知商品' }}</strong>
                    <span>{{ money(item.purchasePrice) }} × {{ item.quantity }}</span>
                  </div>
                  <div class="pay-item__sum">{{ money(item.purchasePrice * item.quantity) }}</div>
                </li>
              </ul>
            </div>

            <footer class="pay-modal__foot">
              <div class="pay-total">
                <span>应付金额</span>
                <strong class="price">{{ money(activeOrder?.totalAmount) }}</strong>
              </div>
              <button class="pay-confirm" :class="{ 'is-locked': payLocked }" :disabled="payLocked" @click="confirmPay">
                <span v-if="paying">支付处理中…</span>
                <span v-else-if="lockSeconds > 0">安全校验中 · {{ lockSeconds }}s</span>
                <span v-else>确认支付 {{ money(activeOrder?.totalAmount) }}</span>
              </button>
              <p class="pay-hint">模拟支付环境，确认后订单将标记为「已付款」。</p>
            </footer>
          </div>
        </div>
      </Transition>
    </Teleport>
  </main>
</template>

<script setup>
import { computed, onBeforeUnmount, onMounted, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { getOrders, getOrderItems, payOrder } from '@/api/order'
import EmptyState from '@/components/ui/EmptyState.vue'
import LuxuryButton from '@/components/ui/LuxuryButton.vue'
import { money, imageUrl } from '@/utils/format'

const page = ref({})
const pageNum = ref(1)
const orders = computed(() => page.value.records || [])
const statusText = ['待付款', '已付款', '已发货', '已完成', '已取消']

async function load() {
  page.value = await getOrders(pageNum.value)
}

// ---- 支付弹窗 ----
const payVisible = ref(false)
const activeOrder = ref(null)
const payItems = ref([])
const itemsLoading = ref(false)
const paying = ref(false)
const lockSeconds = ref(0)
let lockTimer = null

// 锁定中 / 支付中 / 商品加载中 时按钮不可点击
const payLocked = computed(() => lockSeconds.value > 0 || paying.value || itemsLoading.value)

function cover(item) {
  return imageUrl(item.productImage || '')
}

async function openPay(order) {
  activeOrder.value = order
  payItems.value = []
  payVisible.value = true
  itemsLoading.value = true
  startLock()                 // 拉起支付页面即锁定按钮 3 秒
  try {
    payItems.value = await getOrderItems(order.id)
  } catch {
    payItems.value = []       // 错误提示已由 request 拦截器统一处理
  } finally {
    itemsLoading.value = false
  }
}

function startLock() {
  clearLock()
  lockSeconds.value = 3
  lockTimer = setInterval(() => {
    lockSeconds.value -= 1
    if (lockSeconds.value <= 0) clearLock()
  }, 1000)
}

function clearLock() {
  if (lockTimer) {
    clearInterval(lockTimer)
    lockTimer = null
  }
}

function closePay() {
  if (paying.value) return     // 支付进行中不允许关闭
  payVisible.value = false
  clearLock()
  lockSeconds.value = 0
}

async function confirmPay() {
  if (payLocked.value) return
  paying.value = true
  try {
    await payOrder(activeOrder.value.id)
    ElMessage.success('支付成功')
    payVisible.value = false
    clearLock()
    await load()
  } catch {
    // 错误提示已由 request 拦截器统一处理
  } finally {
    paying.value = false
  }
}

onMounted(load)
onBeforeUnmount(clearLock)
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

.order__side {
  display: inline-flex;
  flex-direction: column;
  align-items: flex-end;
  gap: 14px;
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

  .order__side {
    align-items: flex-start;
  }
}

/* ---- 支付弹窗 ---- */
.pay-mask {
  position: fixed;
  inset: 0;
  z-index: 2000;
  display: grid;
  place-items: center;
  padding: 24px;
  background: rgba(0, 0, 0, 0.72);
  backdrop-filter: blur(8px);
}

.pay-modal {
  width: min(520px, 100%);
  max-height: min(86vh, 760px);
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.pay-modal__head {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
  padding: 28px 28px 20px;
  border-bottom: 1px solid var(--color-line);
}

.pay-modal__head h2 {
  margin: 8px 0 0;
  font-size: 28px;
  font-weight: 800;
}

.pay-modal__close {
  flex: none;
  width: 38px;
  height: 38px;
  border: 1px solid var(--color-line);
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.04);
  color: #fff;
  font-size: 22px;
  line-height: 1;
  cursor: pointer;
  transition: background 220ms ease, color 220ms ease;
}

.pay-modal__close:hover {
  background: #fff;
  color: #000;
}

.pay-modal__body {
  padding: 20px 28px;
  overflow-y: auto;
}

.pay-empty {
  margin: 0;
  padding: 28px 0;
  text-align: center;
  color: var(--color-muted);
}

.pay-items {
  list-style: none;
  margin: 0;
  padding: 0;
  display: grid;
  gap: 14px;
}

.pay-item {
  display: grid;
  grid-template-columns: 56px 1fr auto;
  align-items: center;
  gap: 14px;
}

.pay-item__media {
  width: 56px;
  height: 56px;
  border-radius: 14px;
  overflow: hidden;
  border: 1px solid var(--color-line);
  background: rgba(255, 255, 255, 0.05);
  display: grid;
  place-items: center;
}

.pay-item__media img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.pay-item__ph {
  font-size: 20px;
  font-weight: 800;
  color: var(--color-muted);
}

.pay-item__info {
  display: grid;
  gap: 4px;
  min-width: 0;
}

.pay-item__info strong {
  font-size: 15px;
  font-weight: 700;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.pay-item__info span {
  color: var(--color-muted);
  font-size: 13px;
}

.pay-item__sum {
  font-size: 15px;
  font-weight: 800;
  white-space: nowrap;
}

.pay-modal__foot {
  padding: 20px 28px 26px;
  border-top: 1px solid var(--color-line);
  display: grid;
  gap: 16px;
}

.pay-total {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  gap: 16px;
}

.pay-total span {
  color: var(--color-muted);
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 0.14em;
}

.pay-total .price {
  font-size: 34px;
}

.pay-confirm {
  width: 100%;
  min-height: 52px;
  border: 1px solid #fff;
  border-radius: 999px;
  background: #fff;
  color: #000;
  font-size: 15px;
  font-weight: 750;
  cursor: pointer;
  transition: transform 220ms ease, background 220ms ease, color 220ms ease, opacity 220ms ease;
}

.pay-confirm:not(.is-locked):hover {
  transform: translateY(-2px);
  background: #000;
  color: #fff;
}

.pay-confirm.is-locked {
  cursor: not-allowed;
  opacity: 0.55;
  background: rgba(255, 255, 255, 0.12);
  color: var(--color-soft);
  border-color: var(--color-line);
}

.pay-hint {
  margin: 0;
  text-align: center;
  color: var(--color-muted);
  font-size: 12px;
}

.pay-fade-enter-active,
.pay-fade-leave-active {
  transition: opacity 260ms ease;
}

.pay-fade-enter-from,
.pay-fade-leave-to {
  opacity: 0;
}
</style>
