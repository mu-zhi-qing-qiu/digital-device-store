<template>
  <main class="page checkout-page">
    <section class="lux-container checkout">
      <div class="checkout__copy">
        <p class="eyebrow">结算</p>
        <h1 class="display-title">确认订单</h1>
        <p class="body-large">以最少步骤完成购买，并保持高级产品体验的完整性</p>
      </div>

      <div class="checkout__layout">
        <div class="panel checkout-form">
          <label>
            <span>收货人</span>
            <input class="lux-input" placeholder="请输入姓名" />
          </label>
          <label>
            <span>联系电话</span>
            <input class="lux-input" placeholder="请输入手机号" />
          </label>
          <label>
            <span>收货地址</span>
            <textarea class="lux-textarea" placeholder="省 / 市 / 区 / 详细地址" />
          </label>
          <label>
            <span>配送方式</span>
            <select class="lux-select">
              <option>高端速递</option>
              <option>门店自提</option>
            </select>
          </label>
        </div>

        <aside class="summary glass">
          <p class="eyebrow">总计</p>
          <div v-for="item in items" :key="item.id" class="line">
            <span>{{ item.productName }} x {{ item.quantity }}</span>
            <strong>{{ money(Number(item.price) * Number(item.quantity)) }}</strong>
          </div>
          <div class="summary__total">
            <span>应付</span>
            <strong>{{ money(total) }}</strong>
          </div>
          <LuxuryButton block @click="checkout">
            <CheckCircle2 :size="18" />
            提交订单
          </LuxuryButton>
        </aside>
      </div>
    </section>
  </main>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { CheckCircle2 } from '@lucide/vue'
import { ElMessage } from 'element-plus'
import { getCart } from '@/api/cart'
import { placeOrder } from '@/api/order'
import LuxuryButton from '@/components/ui/LuxuryButton.vue'
import { money } from '@/utils/format'

const router = useRouter()
const items = ref([])
const total = computed(() => items.value.reduce((sum, item) => sum + Number(item.price || 0) * Number(item.quantity || 0), 0))

async function checkout() {
  await placeOrder({ items: items.value.map(i => ({ productId: i.productId, quantity: i.quantity })) })
  ElMessage.success('下单成功')
  router.push('/orders')
}

onMounted(async () => {
  items.value = await getCart()
})
</script>

<style scoped>
.checkout {
  padding: 12vh 0 110px;
}

.checkout__copy {
  display: grid;
  max-width: 800px;
  gap: 22px;
  margin-bottom: 42px;
}

.checkout__layout {
  display: grid;
  grid-template-columns: minmax(0, 1fr) 420px;
  gap: 28px;
}

.checkout-form {
  display: grid;
  gap: 18px;
  padding: 28px;
}

label {
  display: grid;
  gap: 10px;
}

label span {
  color: #888;
  font-size: 12px;
  font-weight: 800;
  letter-spacing: 0.12em;
  text-transform: uppercase;
}

.summary {
  display: grid;
  height: max-content;
  gap: 18px;
  border-radius: 28px;
  padding: 28px;
}

.line,
.summary__total {
  display: flex;
  justify-content: space-between;
  gap: 16px;
}

.line span {
  color: #aaa;
}

.summary__total {
  border-top: 1px solid rgba(255, 255, 255, 0.12);
  padding-top: 18px;
}

.summary__total strong {
  font-size: 40px;
  font-weight: 900;
}

@media (max-width: 900px) {
  .checkout__layout {
    grid-template-columns: 1fr;
  }
}
</style>
