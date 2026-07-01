<template>
  <main>
    <section class="hero">
      <div class="cinematic-grid" />
      <div class="hero__content lux-container">
        <p class="eyebrow reveal">高端数码商城</p>
        <h1 class="display-title reveal reveal-delay-1">
          {{'未来设备'}}
        </h1>
        <p class="body-large hero__copy reveal reveal-delay-2">
          {{'为旗舰手机、创作者工作站与智能配件打造的黑标级数码目的地。'}}
        </p>
        <div class="hero__actions reveal reveal-delay-3">
          <LuxuryButton :to="heroProduct ? `/product/${heroProduct.id}` : '/products'">立即购买</LuxuryButton>
          <LuxuryButton variant="ghost" to="/products">探索更多</LuxuryButton>
        </div>
      </div>
      <div class="hero__metrics lux-container">
        <span>4K 渲染级视觉</span>
        <span>黑标精选</span>
        <span>极速发货</span>
      </div>
    </section>

    <section class="section lux-container flagship">
      <article
        v-for="(item, index) in flagshipProducts"
        :key="item.id"
        :class="['feature-row reveal', { 'feature-row--reverse': index % 2 === 1 }]"
      >
        <div class="feature-row__media">
          <img v-if="productImages[item.id]" :src="productImages[item.id]" :alt="item.name" />
          <div v-else class="feature-row__fallback">{{ item.brand || 'Tech' }}</div>
        </div>
        <div class="feature-row__copy">
          <p class="eyebrow">{{ item.brand || '旗舰产品' }}</p>
          <h2 class="section-title">{{ item.name }}</h2>
          <p class="body-large">{{ item.description || '克制的性能、精致的材质，以及以设备为中心的购物体验。' }}</p>
          <LuxuryButton variant="ghost" :to="`/product/${item.id}`">查看细节</LuxuryButton>
        </div>
      </article>
    </section>

    <section class="section hot">
      <div class="hot__pin">
        <div class="lux-container hot__head">
          <div>
            <p class="eyebrow">热门设备</p>
            <h2 class="section-title">热门商品，快速预览</h2>
          </div>
          <LuxuryButton variant="ghost" to="/products">全部产品</LuxuryButton>
        </div>
        <div class="hot__rail thin-scrollbar">
          <ProductCard
            v-for="item in products.slice(0, 8)"
            :key="item.id"
            :product="item"
            :image="productImages[item.id]"
            @quick-add="quickAdd"
          />
        </div>
      </div>
    </section>

    <section class="section lux-container philosophy">
      <div class="philosophy__copy">
        <p class="eyebrow">设计理念</p>
        <h2 class="section-title">更少货架噪音，更多产品欲望。</h2>
      </div>
      <div class="philosophy__grid">
        <div v-for="item in ideals" :key="item.title" class="ideal panel">
          <span>{{ item.index }}</span>
          <h3>{{ item.title }}</h3>
          <p>{{ item.text }}</p>
        </div>
      </div>
    </section>

    <section class="section lux-container testimonials">
      <p class="eyebrow">用户评价</p>
      <div class="quote-row">
        <blockquote v-for="item in quotes" :key="item.name">
          <p>{{ item.text }}</p>
          <cite>{{ item.name }}</cite>
        </blockquote>
      </div>
    </section>
  </main>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import { getProducts } from '@/api/product'
import { getCategories } from '@/api/category'
import { addToCart } from '@/api/cart'
import { ElMessage } from 'element-plus'
import LuxuryButton from '@/components/ui/LuxuryButton.vue'
import ProductCard from '@/components/product/ProductCard.vue'
import { attachProductImages } from '@/utils/productImages'

const categories = ref([])
const products = ref([])
const selectedCategory = ref(null)
const keyword = ref('')
const pageNum = ref(1)
const pageSize = ref(12)
const total = ref(0)
const productImages = ref({})

const heroProduct = computed(() => products.value[0])
const flagshipProducts = computed(() => products.value.slice(1, 4))

const ideals = [
  { index: '01', title: '电影级聚焦', text: '每个视口都给核心设备足够空间，让产品本身成为视觉中心。' },
  { index: '02', title: '黑标级体验', text: '控件安静、精确，并围绕真正的购买决策时刻构建。' },
  { index: '03', title: '克制的动效', text: '悬停、揭示与视差带来深度，但不抢走产品的注意力。' }
]

const quotes = [
  { name: '林先生，工业设计师', text: '这里更像一场发布会，而不是传统购物车。产品比较终于变得安静。' },
  { name: '陈女士，创作者', text: '图片足够大，可以判断质感；结算流程也保持了高级感。' },
  { name: '王先生，创业者', text: '克制、直接、自信。它在不喧哗的情况下完成销售。' }
]

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
.hero {
  position: relative;
  display: grid;
  min-height: 100vh;
  place-items: center;
  overflow: hidden;
  padding-top: var(--nav-height);
  background: #000;
}

.hero__content {
  position: relative;
  z-index: 2;
  display: grid;
  justify-items: center;
  text-align: center;
}

.hero__copy {
  max-width: 720px;
  margin: 24px auto 0;
}

.hero__actions {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  gap: 14px;
  margin-top: 34px;
}

.hero__metrics {
  position: absolute;
  z-index: 3;
  bottom: 28px;
  display: flex;
  justify-content: space-between;
  color: #777;
  font-size: 12px;
  font-weight: 800;
  letter-spacing: 0.12em;
  text-transform: uppercase;
}

.flagship {
  display: grid;
  gap: 80px;
}

.feature-row {
  display: grid;
  grid-template-columns: minmax(0, 1.15fr) minmax(320px, 0.85fr);
  align-items: center;
  gap: 56px;
}

.feature-row--reverse .feature-row__media {
  order: 2;
}

.feature-row__media {
  display: grid;
  min-height: 520px;
  place-items: center;
  overflow: hidden;
  border-radius: 32px;
  background:
    radial-gradient(circle at 50% 38%, rgba(255, 255, 255, 0.12), transparent 42%),
    #0c0c0c;
}

.feature-row__media img {
  width: 88%;
  height: 460px;
  object-fit: contain;
  transition: transform 900ms cubic-bezier(0.16, 1, 0.3, 1);
}

.feature-row:hover img {
  transform: scale(1.06);
}

.feature-row__fallback {
  color: #555;
  font-size: 56px;
  font-weight: 900;
}

.feature-row__copy {
  display: grid;
  justify-items: start;
  gap: 24px;
}

.hot {
  --hot-side: max(24px, calc((100vw - 1440px) / 2));
  position: relative;
  min-height: 280vh;
  overflow: clip;
  view-timeline-name: --hot-scroll;
  view-timeline-axis: block;
  padding-top: 0;
  padding-bottom: 0;
}

.hot__pin {
  position: sticky;
  top: var(--nav-height);
  display: grid;
  min-height: calc(100vh - var(--nav-height));
  align-content: center;
  gap: 32px;
  overflow: hidden;
  padding: 72px 0;
  background: linear-gradient(180deg, rgba(0, 0, 0, 0.96), rgba(0, 0, 0, 0.82));
}

.hot__head {
  z-index: 2;
  display: flex;
  align-items: end;
  justify-content: space-between;
  gap: 24px;
  margin-bottom: 0;
}

.hot__rail {
  display: grid;
  width: max-content;
  grid-auto-columns: clamp(292px, 28vw, 380px);
  grid-auto-flow: column;
  gap: 22px;
  overflow: visible;
  padding: 0 var(--hot-side) 18px;
  scrollbar-width: none;
  will-change: transform;
  animation: hot-rail-pan linear both;
  animation-timeline: --hot-scroll;
  animation-range: contain 0% contain 100%;
}

.hot__rail::-webkit-scrollbar {
  display: none;
}

@keyframes hot-rail-pan {
  from {
    transform: translateX(0);
  }

  to {
    transform: translateX(calc(-100% + 100vw));
  }
}

@supports not ((view-timeline-name: --hot-scroll) and (animation-timeline: --hot-scroll)) {
  .hot {
    min-height: auto;
    overflow: hidden;
  }

  .hot__pin {
    position: static;
    min-height: auto;
    padding: 0;
    background: transparent;
  }

  .hot__rail {
    width: auto;
    overflow-x: auto;
    animation: none;
  }
}

.philosophy {
  display: grid;
  grid-template-columns: 0.9fr 1.1fr;
  gap: 44px;
  align-items: start;
}

.philosophy__grid {
  display: grid;
  gap: 16px;
}

.ideal {
  padding: 28px;
}

.ideal span {
  color: #666;
  font-size: 13px;
  font-weight: 900;
}

.ideal h3 {
  margin: 20px 0 12px;
  font-size: 28px;
}

.ideal p {
  margin: 0;
  color: #aaa;
  line-height: 1.7;
}

.testimonials {
  display: grid;
  gap: 28px;
}

.quote-row {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 18px;
}

blockquote {
  margin: 0;
  border-radius: 24px;
  padding: 30px;
  background: rgba(255, 255, 255, 0.05);
}

blockquote p {
  margin: 0 0 28px;
  color: #eee;
  font-size: 22px;
  line-height: 1.45;
}

cite {
  color: #888;
  font-style: normal;
}

@media (max-width: 900px) {

  .feature-row--reverse .feature-row__media {
    order: 0;
  }

  .feature-row__media {
    min-height: 360px;
  }

  .feature-row__media img {
    height: 320px;
  }

  .hero__metrics {
    display: none;
  }

  .hot {
    min-height: auto;
  }

  .hot__pin {
    position: static;
    min-height: auto;
    padding: 0;
    background: transparent;
  }

  .hot__rail {
    width: auto;
    overflow-x: auto;
    animation: none;
  }
}
</style>

