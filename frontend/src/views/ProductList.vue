<template>
  <main class="page product-list">
    <section class="list-hero">
      <div class="cinematic-grid" />
      <div class="lux-container list-hero__inner">
        <p class="eyebrow reveal">精选目录</p>
        <h1 class="display-title reveal reveal-delay-1">为旗舰设备打造的安静目录。</h1>
        <p class="body-large reveal reveal-delay-2">用发布会式的大图浏览、精准筛选和克制排版，替代拥挤的传统货架。</p>
      </div>
    </section>

    <section class="lux-container catalog">
      <aside class="filters glass">
        <label>
          <span>搜索</span>
          <input v-model="keyword" class="lux-input" placeholder="iPhone / MateBook / AirPods" @keyup.enter="applyFilters" />
        </label>
        <label>
          <span>分类</span>
          <select v-model="selectedCategory" class="lux-select" @change="applyFilters">
            <option :value="null">全部分类</option>
            <option v-for="category in categories" :key="category.id" :value="category.id">{{ category.name }}</option>
          </select>
        </label>
        <label>
          <span>品牌</span>
          <select v-model="selectedBrand" class="lux-select">
            <option value="">全部品牌</option>
            <option v-for="brand in brands" :key="brand" :value="brand">{{ brand }}</option>
          </select>
        </label>
        <label>
          <span>排序</span>
          <select v-model="sortMode" class="lux-select">
            <option value="featured">精选优先</option>
            <option value="priceDesc">价格从高到低</option>
            <option value="priceAsc">价格从低到高</option>
          </select>
        </label>
        <LuxuryButton block @click="applyFilters">
          <SlidersHorizontal :size="17" />
          应用筛选
        </LuxuryButton>
      </aside>

      <div class="catalog__main">
        <div class="catalog__top">
          <p>{{ total }} 件高端设备</p>
          <span>Apple Store 式布局</span>
        </div>
        <div v-if="sortedProducts.length" class="masonry">
          <ProductCard
            v-for="item in sortedProducts"
            :key="item.id"
            :product="item"
            :image="productImages[item.id]"
            @quick-add="quickAdd"
          />
        </div>
        <EmptyState v-else title="没有匹配产品" text="换一个关键词，或清空筛选条件后继续探索。" />
        <el-pagination
          v-if="total > pageSize"
          v-model:current-page="pageNum"
          :page-size="pageSize"
          :total="total"
          layout="prev, pager, next"
          @current-change="fetchProducts"
        />
      </div>
    </section>
  </main>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import { SlidersHorizontal } from '@lucide/vue'
import { ElMessage } from 'element-plus'
import { addToCart } from '@/api/cart'
import { getCategories } from '@/api/category'
import { getProducts } from '@/api/product'
import LuxuryButton from '@/components/ui/LuxuryButton.vue'
import EmptyState from '@/components/ui/EmptyState.vue'
import ProductCard from '@/components/product/ProductCard.vue'
import { attachProductImages } from '@/utils/productImages'

const categories = ref([])
const products = ref([])
const selectedCategory = ref(null)
const selectedBrand = ref('')
const keyword = ref('')
const sortMode = ref('featured')
const pageNum = ref(1)
const pageSize = ref(12)
const total = ref(0)
const productImages = ref({})

const brands = computed(() => [...new Set(products.value.map(item => item.brand).filter(Boolean))])
const filteredProducts = computed(() => (
  selectedBrand.value ? products.value.filter(item => item.brand === selectedBrand.value) : products.value
))
const sortedProducts = computed(() => {
  const list = [...filteredProducts.value]
  if (sortMode.value === 'priceDesc') return list.sort((a, b) => Number(b.price) - Number(a.price))
  if (sortMode.value === 'priceAsc') return list.sort((a, b) => Number(a.price) - Number(b.price))
  return list
})

async function fetchProducts() {
  const res = await getProducts({
    pageNum: pageNum.value,
    pageSize: pageSize.value,
    categoryId: selectedCategory.value || undefined,
    keyword: keyword.value || undefined
  })
  products.value = res.records || []
  total.value = res.total || 0
  productImages.value = await attachProductImages(products.value)
}

function applyFilters() {
  pageNum.value = 1
  fetchProducts()
}

async function quickAdd(product) {
  await addToCart({ productId: product.id, quantity: 1 })
  ElMessage.success('已加入购物车')
}

onMounted(async () => {
  categories.value = await getCategories()
  fetchProducts()
})
</script>

<style scoped>
.list-hero {
  position: relative;
  min-height: 58vh;
  overflow: hidden;
  background: #000;
}

.list-hero__inner {
  position: relative;
  z-index: 1;
  display: grid;
  max-width: 940px;
  gap: 24px;
  padding-top: 15vh;
}

.catalog {
  display: grid;
  grid-template-columns: 292px minmax(0, 1fr);
  gap: 28px;
  padding: 54px 0 110px;
}

.filters {
  position: sticky;
  top: 92px;
  display: grid;
  height: max-content;
  gap: 18px;
  border-radius: 28px;
  padding: 22px;
}

.filters label {
  display: grid;
  gap: 10px;
}

.filters span {
  color: #888;
  font-size: 12px;
  font-weight: 800;
  letter-spacing: 0.12em;
  text-transform: uppercase;
}

.catalog__main {
  display: grid;
  gap: 26px;
}

.catalog__top {
  display: flex;
  justify-content: space-between;
  color: #888;
}

.catalog__top p,
.catalog__top span {
  margin: 0;
}

.masonry {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 20px;
}

.masonry :deep(.product-card:nth-child(3n + 2)) {
  transform: translateY(34px);
}

@media (max-width: 1080px) {
  .catalog {
    grid-template-columns: 1fr;
  }

  .filters {
    position: relative;
    top: auto;
    grid-template-columns: repeat(2, 1fr);
  }

  .masonry {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 680px) {
  .filters,
  .masonry {
    grid-template-columns: 1fr;
  }

  .masonry :deep(.product-card:nth-child(3n + 2)) {
    transform: none;
  }
}
</style>
