<template>
  <div style="max-width:900px;margin:30px auto;padding:0 20px">
    <el-row :gutter="24">
      <el-col :span="14">
        <el-image v-if="images[0]" :src="images[0].url" fit="cover" style="width:100%;border-radius:8px" />
        <el-empty v-else description="暂无图片" />
      </el-col>
      <el-col :span="10">
        <h2>{{ product.name }}</h2>
        <div style="color:#e6a23c;font-size:28px;margin:12px 0">¥{{ product.price }}</div>
        <el-descriptions :column="1" border size="small" style="margin-bottom:16px">
          <el-descriptions-item label="品牌">{{ product.brand }}</el-descriptions-item>
          <el-descriptions-item label="库存">{{ product.stock }}</el-descriptions-item>
        </el-descriptions>
        <p style="color:#666">{{ product.description }}</p>
        <el-input-number v-model="qty" :min="1" :max="product.stock" style="margin:16px 0" />
        <el-button type="primary" size="large" @click="addCart" :disabled="!store.isLoggedIn">
          {{ store.isLoggedIn ? '加入购物车' : '请先登录' }}
        </el-button>
      </el-col>
    </el-row>
    <!-- 评论区 -->
    <el-divider content-position="left">商品评价</el-divider>
    <div v-for="r in reviews" :key="r.id" style="margin-bottom:12px">
      <el-rate :model-value="r.rating" disabled />
      <p style="margin:4px 0 0">{{ r.content }}</p>
      <el-divider />
    </div>
    <!-- 写评价 -->
    <div v-if="store.isLoggedIn" style="margin-top:16px">
      <el-rate v-model="reviewForm.rating" style="margin-bottom:8px" />
      <el-input v-model="reviewForm.content" type="textarea" placeholder="写下你的评价..." :rows="3" />
      <el-button type="primary" style="margin-top:8px" @click="submitReview">提交评价</el-button>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { getProduct, getImages } from '@/api/product'
import { getReviews, addReview } from '@/api/review'
import { addToCart } from '@/api/cart'
import { ElMessage } from 'element-plus'

const route  = useRoute()
const store  = useUserStore()
const id     = route.params.id
const product    = ref({})
const images     = ref([])
const reviews    = ref([])
const qty        = ref(1)
const reviewForm = reactive({ rating: 5, content: '' })

async function addCart() {
  await addToCart({ userId: store.user.id, productId: id, quantity: qty.value })
  ElMessage.success('已加入购物车')
}

async function submitReview() {
  await addReview({ userId: store.user.id, productId: id, ...reviewForm })
  ElMessage.success('评价成功')
  reviews.value = await getReviews(id)
  reviewForm.content = ''
}

onMounted(async () => {
  ;[product.value, images.value, reviews.value] = await Promise.all([
    getProduct(id), getImages(id), getReviews(id)
  ])
})
</script>
