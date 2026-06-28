<template>
  <main class="page detail-page">
    <section class="detail lux-container">
      <div class="gallery">
        <div v-for="(image, index) in displayImages" :key="image.id || index" class="gallery__frame">
          <img v-if="image.url" :src="imageUrl(image.url)" :alt="product.name" />
          <div v-else class="gallery__fallback">DS</div>
        </div>
      </div>

      <aside class="buy-panel glass">
        <div>
          <p class="eyebrow">{{ product.brand || '旗舰设备' }}</p>
          <h1>{{ product.name }}</h1>
          <p class="tagline">{{ product.description || '为现代工作、娱乐与创作精选的精密设备。' }}</p>
        </div>

        <div class="price">{{ money(product.price) }}</div>

        <div class="option-group">
          <span>颜色</span>
          <div class="swatches">
            <button
              v-for="color in colors"
              :key="color.name"
              :class="{ active: selectedColor === color.name }"
              :style="{ background: color.value }"
              :title="color.name"
              type="button"
              @click="selectedColor = color.name"
            />
          </div>
        </div>

        <div class="option-group">
          <span>容量</span>
          <div class="chips">
            <button
              v-for="capacity in capacities"
              :key="capacity"
              :class="{ active: selectedCapacity === capacity }"
              type="button"
              @click="selectedCapacity = capacity"
            >
              {{ capacity }}
            </button>
          </div>
        </div>

        <div class="quantity">
          <span>数量</span>
          <div>
            <button type="button" @click="qty = Math.max(1, qty - 1)">-</button>
            <strong>{{ qty }}</strong>
            <button type="button" @click="qty += 1">+</button>
          </div>
        </div>

        <LuxuryButton block @click="addCart">
          <ShoppingBag :size="18" />
          加入购物车
        </LuxuryButton>
        <LuxuryButton block variant="ghost" to="/cart">前往结算</LuxuryButton>
      </aside>
    </section>

    <section class="lux-container specs">
      <div class="spec panel" v-for="item in specs" :key="item.label">
        <span>{{ item.label }}</span>
        <strong>{{ item.value }}</strong>
      </div>
    </section>

    <section class="lux-container reviews">
      <div class="reviews__head">
        <div>
          <p class="eyebrow">用户评价</p>
          <h2 class="section-title">真实反馈，保持克制。</h2>
        </div>
      </div>
      <div class="reviews__grid">
        <article v-for="review in reviews" :key="review.id" class="review panel">
          <strong>{{ review.rating || 5 }}.0</strong>
          <p>{{ review.content }}</p>
        </article>
        <form v-if="store.isLoggedIn" class="review-form panel" @submit.prevent="submitReview">
          <select v-model="reviewForm.rating" class="lux-select">
            <option v-for="rating in [5, 4, 3, 2, 1]" :key="rating" :value="rating">{{ rating }} 星</option>
          </select>
          <textarea v-model="reviewForm.content" class="lux-textarea" placeholder="写下你的使用体验" />
          <LuxuryButton type="submit">提交评价</LuxuryButton>
        </form>
      </div>
    </section>
  </main>
</template>

<script setup>
import { computed, onMounted, reactive, ref } from 'vue'
import { useRoute } from 'vue-router'
import { ShoppingBag } from '@lucide/vue'
import { useUserStore } from '@/stores/user'
import { getProduct, getImages } from '@/api/product'
import { getReviews, addReview } from '@/api/review'
import { addToCart } from '@/api/cart'
import { ElMessage } from 'element-plus'
import LuxuryButton from '@/components/ui/LuxuryButton.vue'
import { imageUrl, money } from '@/utils/format'

const route = useRoute()
const store = useUserStore()
const id = route.params.id
const product = ref({})
const images = ref([])
const reviews = ref([])
const qty = ref(1)
const selectedColor = ref('曜石黑')
const selectedCapacity = ref('512GB')
const reviewForm = reactive({ rating: 5, content: '' })

const colors = [
  { name: '曜石黑', value: '#050505' },
  { name: '钛金灰', value: '#8a8a8a' },
  { name: '雪域白', value: '#f4f4f4' }
]
const capacities = ['256GB', '512GB', '1TB']
const displayImages = computed(() => (images.value.length ? images.value : [{ url: '' }]))
const specs = computed(() => [
  { label: '品牌', value: product.value.brand || '数码臻选' },
  { label: '库存', value: `${product.value.stock ?? 0} 件` },
  { label: '颜色', value: selectedColor.value },
  { label: '容量', value: selectedCapacity.value }
])

async function addCart() {
  await addToCart({ productId: id, quantity: qty.value })
  ElMessage.success('已加入购物车')
}

async function submitReview() {
  await addReview({ productId: id, ...reviewForm })
  ElMessage.success('评价已提交')
  reviews.value = await getReviews(id)
  reviewForm.content = ''
}

onMounted(async () => {
  ;[product.value, images.value, reviews.value] = await Promise.all([
    getProduct(id), getImages(id), getReviews(id)
  ])
})
</script>

<style scoped>
.detail {
  display: grid;
  grid-template-columns: minmax(0, 1.2fr) minmax(360px, 0.8fr);
  gap: 36px;
  padding: 42px 0 76px;
}

.gallery {
  display: grid;
  gap: 24px;
}

.gallery__frame {
  display: grid;
  min-height: 72vh;
  place-items: center;
  overflow: hidden;
  border-radius: 34px;
  background:
    radial-gradient(circle at 50% 42%, rgba(255, 255, 255, 0.13), transparent 44%),
    #080808;
}

.gallery__frame img {
  width: 88%;
  height: 62vh;
  object-fit: contain;
  filter: drop-shadow(0 34px 70px rgba(0, 0, 0, 0.72));
  transition: transform 900ms cubic-bezier(0.16, 1, 0.3, 1);
}

.gallery__frame:hover img {
  transform: scale(1.08);
}

.gallery__fallback {
  color: rgba(255, 255, 255, 0.18);
  font-size: 96px;
  font-weight: 900;
}

.buy-panel {
  position: sticky;
  top: 96px;
  display: grid;
  height: max-content;
  gap: 26px;
  border-radius: 30px;
  padding: 30px;
}

h1 {
  margin: 12px 0 0;
  font-size: clamp(40px, 4.6vw, 68px);
  line-height: 0.98;
}

.tagline {
  color: #aaa;
  font-size: 17px;
  line-height: 1.7;
}

.option-group {
  display: grid;
  gap: 12px;
}

.option-group span,
.quantity span {
  color: #888;
  font-size: 12px;
  font-weight: 800;
  letter-spacing: 0.12em;
  text-transform: uppercase;
}

.swatches,
.chips {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.swatches button {
  width: 42px;
  height: 42px;
  border: 2px solid rgba(255, 255, 255, 0.16);
  border-radius: 50%;
  cursor: pointer;
}

.swatches button.active,
.chips button.active {
  border-color: #fff;
}

.chips button {
  height: 44px;
  border: 1px solid rgba(255, 255, 255, 0.14);
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.04);
  color: #fff;
  padding: 0 18px;
  cursor: pointer;
}

.quantity {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.quantity div {
  display: inline-flex;
  align-items: center;
  gap: 18px;
  border: 1px solid rgba(255, 255, 255, 0.14);
  border-radius: 999px;
  padding: 6px;
}

.quantity button {
  width: 34px;
  height: 34px;
  border: 0;
  border-radius: 50%;
  background: #fff;
  color: #000;
  cursor: pointer;
}

.specs {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
  padding-bottom: 92px;
}

.spec {
  display: grid;
  gap: 14px;
  padding: 24px;
}

.spec span {
  color: #777;
  font-size: 12px;
  font-weight: 800;
  text-transform: uppercase;
}

.spec strong {
  font-size: 24px;
}

.reviews {
  display: grid;
  gap: 28px;
  padding-bottom: 110px;
}

.reviews__grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 18px;
}

.review,
.review-form {
  display: grid;
  gap: 16px;
  padding: 24px;
}

.review strong {
  font-size: 34px;
}

.review p {
  margin: 0;
  color: #ddd;
  line-height: 1.7;
}

@media (max-width: 980px) {
  .detail,
  .reviews__grid {
    grid-template-columns: 1fr;
  }

  .buy-panel {
    position: relative;
    top: auto;
  }

  .specs {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 620px) {
  .gallery__frame {
    min-height: 420px;
  }

  .gallery__frame img {
    height: 360px;
  }

  .specs {
    grid-template-columns: 1fr;
  }
}
</style>
