<template>
  <main class="page cart-page">
    <section class="lux-container cart-head">
      <p class="eyebrow">购物车</p>
      <h1 class="display-title">安静的购物车，只突出决定。</h1>
    </section>

    <section class="lux-container cart-layout">
      <div v-if="items.length" class="cart-items">
        <article v-for="item in items" :key="item.id" class="cart-item panel">
          <div class="cart-item__media">
            <img v-if="item.imageUrl" :src="imageUrl(item.imageUrl)" :alt="item.productName" />
            <span v-else>{{ item.brand || 'DS' }}</span>
          </div>
          <div class="cart-item__info">
            <p>{{ item.brand || '数码臻选' }}</p>
            <h2>{{ item.productName }}</h2>
            <span>数量 {{ item.quantity }}</span>
          </div>
          <strong>{{ money(Number(item.price) * Number(item.quantity)) }}</strong>
          <button type="button" title="移除" @click="remove(item.id)">
            <Trash2 :size="18" />
          </button>
        </article>
      </div>
      <EmptyState v-else title="购物车为空" text="从精选目录选择你的下一件设备。">
        <LuxuryButton to="/products">探索产品</LuxuryButton>
      </EmptyState>

      <aside class="summary glass">
        <p class="eyebrow">订单摘要</p>
        <div class="summary__row">
          <span>商品数量</span>
          <strong>{{ itemCount }}</strong>
        </div>
        <div class="summary__row">
          <span>配送</span>
          <strong>高端配送</strong>
        </div>
        <div class="summary__total">
          <span>总计</span>
          <strong>{{ money(total) }}</strong>
        </div>
        <LuxuryButton block :to="items.length ? '/checkout' : '/products'">
          <CreditCard :size="18" />
          {{ items.length ? '结算' : '去选购' }}
        </LuxuryButton>
      </aside>
    </section>
  </main>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import { CreditCard, Trash2 } from '@lucide/vue'
import { getCart, removeFromCart } from '@/api/cart'
import LuxuryButton from '@/components/ui/LuxuryButton.vue'
import EmptyState from '@/components/ui/EmptyState.vue'
import { imageUrl, money } from '@/utils/format'

const items = ref([])
const itemCount = computed(() => items.value.reduce((sum, item) => sum + Number(item.quantity || 0), 0))
const total = computed(() => items.value.reduce((sum, item) => sum + Number(item.price || 0) * Number(item.quantity || 0), 0))

async function load() {
  items.value = await getCart()
}

async function remove(id) {
  await removeFromCart(id)
  load()
}

onMounted(load)
</script>

<style scoped>
.cart-head {
  display: grid;
  max-width: 980px;
  gap: 22px;
  padding: 12vh 0 44px;
}

.cart-layout {
  display: grid;
  grid-template-columns: minmax(0, 1fr) 380px;
  gap: 28px;
  padding-bottom: 110px;
}

.cart-items {
  display: grid;
  gap: 16px;
}

.cart-item {
  display: grid;
  grid-template-columns: 150px 1fr auto auto;
  align-items: center;
  gap: 22px;
  padding: 18px;
}

.cart-item__media {
  display: grid;
  height: 128px;
  place-items: center;
  overflow: hidden;
  border-radius: 20px;
  background: #080808;
}

.cart-item__media img {
  width: 92%;
  height: 110px;
  object-fit: contain;
}

.cart-item__media span {
  color: #555;
  font-weight: 900;
}

.cart-item__info p,
.cart-item__info span {
  margin: 0;
  color: #888;
}

.cart-item__info h2 {
  margin: 8px 0;
  font-size: 28px;
}

.cart-item strong {
  font-size: 28px;
}

.cart-item button {
  display: grid;
  width: 42px;
  height: 42px;
  place-items: center;
  border: 1px solid rgba(255, 255, 255, 0.14);
  border-radius: 50%;
  background: transparent;
  color: #fff;
  cursor: pointer;
}

.summary {
  position: sticky;
  top: 96px;
  display: grid;
  height: max-content;
  gap: 22px;
  border-radius: 28px;
  padding: 28px;
}

.summary__row,
.summary__total {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.summary__row span {
  color: #888;
}

.summary__total {
  border-top: 1px solid rgba(255, 255, 255, 0.12);
  padding-top: 22px;
}

.summary__total span {
  color: #ddd;
}

.summary__total strong {
  font-size: 42px;
  font-weight: 900;
}

@media (max-width: 980px) {
  .cart-layout,
  .cart-item {
    grid-template-columns: 1fr;
  }

  .summary {
    position: relative;
    top: auto;
  }
}
</style>
