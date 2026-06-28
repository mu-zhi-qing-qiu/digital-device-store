<template>
  <main class="page search-page">
    <section class="lux-container search-stage">
      <p class="eyebrow">搜索</p>
      <h1 class="display-title">寻找你的下一件主力设备。</h1>
      <div class="search-box glass">
        <SearchIcon :size="24" />
        <input v-model="keyword" placeholder="搜索手机、笔记本、耳机、配件" autofocus @keyup.enter="runSearch" />
        <LuxuryButton @click="runSearch">搜索</LuxuryButton>
      </div>
    </section>

    <section class="lux-container search-results">
      <div v-if="products.length" class="grid">
        <ProductCard
          v-for="item in products"
          :key="item.id"
          :product="item"
          :image="productImages[item.id]"
          @quick-add="quickAdd"
        />
      </div>
      <EmptyState v-else title="输入关键词开始搜索" text="搜索结果会以产品展示页的节奏呈现，而不是拥挤列表。" />
    </section>
  </main>
</template>

<script setup>
import { ref } from 'vue'
import { Search as SearchIcon } from '@lucide/vue'
import { ElMessage } from 'element-plus'
import { getProducts } from '@/api/product'
import { addToCart } from '@/api/cart'
import LuxuryButton from '@/components/ui/LuxuryButton.vue'
import EmptyState from '@/components/ui/EmptyState.vue'
import ProductCard from '@/components/product/ProductCard.vue'
import { attachProductImages } from '@/utils/productImages'

const keyword = ref('')
const products = ref([])
const productImages = ref({})

async function runSearch() {
  if (!keyword.value.trim()) return
  const res = await getProducts({ pageNum: 1, pageSize: 12, keyword: keyword.value })
  products.value = res.records || []
  productImages.value = await attachProductImages(products.value)
}

async function quickAdd(product) {
  await addToCart({ productId: product.id, quantity: 1 })
  ElMessage.success('已加入购物车')
}
</script>

<style scoped>
.search-stage {
  display: grid;
  gap: 28px;
  padding: 12vh 0 48px;
}

.search-box {
  display: grid;
  grid-template-columns: auto 1fr auto;
  align-items: center;
  gap: 16px;
  border-radius: 999px;
  padding: 10px 10px 10px 22px;
}

.search-box input {
  height: 56px;
  border: 0;
  background: transparent;
  color: #fff;
  font-size: 22px;
  outline: none;
}

.search-results {
  padding-bottom: 110px;
}

.grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 20px;
}

@media (max-width: 1100px) {
  .grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 680px) {
  .search-box {
    grid-template-columns: auto 1fr;
    border-radius: 26px;
  }

  .search-box .lux-button {
    grid-column: 1 / -1;
  }

  .grid {
    grid-template-columns: 1fr;
  }
}
</style>
