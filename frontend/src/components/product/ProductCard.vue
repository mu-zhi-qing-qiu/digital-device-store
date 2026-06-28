<template>
  <article class="product-card" @click="router.push(`/product/${product.id}`)">
    <div class="product-card__media">
      <img v-if="resolvedImage" :src="resolvedImage" :alt="product.name" loading="lazy" />
      <div v-else class="product-card__fallback">{{ initials }}</div>
      <button class="product-card__quick" type="button" title="快速加入购物车" @click.stop="$emit('quick-add', product)">
        <ShoppingBag :size="18" />
      </button>
    </div>
    <div class="product-card__body">
      <div>
        <p class="product-card__brand">{{ product.brand || '数码臻选' }}</p>
        <h3>{{ product.name }}</h3>
      </div>
      <div class="product-card__meta">
        <span>{{ subtitle }}</span>
        <strong>{{ money(product.price) }}</strong>
      </div>
    </div>
  </article>
</template>

<script setup>
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import { ShoppingBag } from '@lucide/vue'
import { imageUrl, money, shortText } from '@/utils/format'

const props = defineProps({
  product: { type: Object, required: true },
  image: { type: String, default: '' }
})

defineEmits(['quick-add'])

const router = useRouter()
const resolvedImage = computed(() => imageUrl(props.image || props.product.imageUrl || props.product.cover))
const subtitle = computed(() => shortText(props.product.description, '为高性能体验而生的精密数码设备。'))
const initials = computed(() => String(props.product.name || '科技').slice(0, 2).toUpperCase())
</script>

<style scoped>
.product-card {
  display: grid;
  min-width: 292px;
  overflow: hidden;
  border: 1px solid rgba(255, 255, 255, 0.08);
  border-radius: 22px;
  background:
    radial-gradient(circle at 50% 0%, rgba(255, 255, 255, 0.08), transparent 52%),
    #121212;
  cursor: pointer;
  transition: transform 260ms ease, border-color 260ms ease, box-shadow 260ms ease;
}

.product-card:hover {
  transform: translateY(-8px) scale(1.015);
  border-color: rgba(255, 255, 255, 0.46);
  box-shadow: 0 24px 80px rgba(0, 0, 0, 0.42);
}

.product-card__media {
  position: relative;
  display: grid;
  min-height: 270px;
  place-items: center;
  overflow: hidden;
  background:
    linear-gradient(145deg, rgba(255, 255, 255, 0.07), transparent),
    #0b0b0b;
}

.product-card__media img {
  width: 86%;
  height: 246px;
  object-fit: contain;
  filter: drop-shadow(0 22px 36px rgba(0, 0, 0, 0.58));
  transition: transform 620ms cubic-bezier(0.16, 1, 0.3, 1);
}

.product-card:hover .product-card__media img {
  transform: scale(1.08);
}

.product-card__fallback {
  display: grid;
  width: 148px;
  height: 148px;
  place-items: center;
  border: 1px solid rgba(255, 255, 255, 0.12);
  border-radius: 50%;
  color: #ddd;
  font-size: 32px;
  font-weight: 800;
}

.product-card__quick {
  position: absolute;
  right: 18px;
  bottom: 18px;
  display: grid;
  width: 42px;
  height: 42px;
  place-items: center;
  border: 1px solid rgba(255, 255, 255, 0.18);
  border-radius: 50%;
  background: rgba(0, 0, 0, 0.72);
  color: #fff;
  cursor: pointer;
  backdrop-filter: blur(18px);
  transition: background 220ms ease, color 220ms ease, transform 220ms ease;
}

.product-card__quick:hover {
  transform: scale(1.08);
  background: #fff;
  color: #000;
}

.product-card__body {
  display: grid;
  gap: 22px;
  padding: 24px;
}

.product-card__brand {
  margin: 0 0 8px;
  color: #888;
  font-size: 12px;
  font-weight: 800;
  letter-spacing: 0.12em;
  text-transform: uppercase;
}

h3 {
  min-height: 2.25em;
  margin: 0;
  color: #fff;
  font-size: 24px;
  line-height: 1.12;
  font-weight: 760;
}

.product-card__meta {
  display: flex;
  min-height: 72px;
  align-items: end;
  justify-content: space-between;
  gap: 18px;
}

.product-card__meta span {
  display: -webkit-box;
  max-width: 58%;
  overflow: hidden;
  color: #888;
  font-size: 13px;
  line-height: 1.5;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
}

.product-card__meta strong {
  color: #fff;
  font-size: 30px;
  font-weight: 900;
  white-space: nowrap;
}
</style>

