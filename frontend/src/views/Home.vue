<template>
  <div style="max-width:1200px;margin:0 auto;padding:20px">
    <!-- 分类筛选 -->
    <el-row :gutter="12" style="margin-bottom:16px">
      <el-col :span="24">
        <el-radio-group v-model="selectedCategory" @change="fetchProducts">
          <el-radio-button :value="null">全部</el-radio-button>
          <el-radio-button v-for="c in categories" :key="c.id" :value="c.id">{{ c.name }}</el-radio-button>
        </el-radio-group>
      </el-col>
    </el-row>
    <!-- 搜索 -->
    <el-input v-model="keyword" placeholder="搜索商品..." clearable style="max-width:300px;margin-bottom:16px"
      @input="fetchProducts" />
    <!-- 商品列表 -->
    <el-row :gutter="16">
      <el-col v-for="p in products" :key="p.id" :xs="12" :sm="8" :md="6" style="margin-bottom:16px">
        <el-card shadow="hover" style="cursor:pointer" @click="router.push(`/product/${p.id}`)">
          <div style="font-weight:bold;margin-bottom:8px">{{ p.name }}</div>
          <div style="color:#e6a23c;font-size:18px">¥{{ p.price }}</div>
          <div style="color:#999;font-size:12px">{{ p.brand }}</div>
        </el-card>
      </el-col>
    </el-row>
    <el-pagination background layout="prev,pager,next" :total="total" :page-size="pageSize"
      v-model:current-page="pageNum" @current-change="fetchProducts" style="margin-top:16px;justify-content:center;display:flex" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { getProducts } from '@/api/product'
import { getCategories } from '@/api/category'

const router = useRouter()
const categories     = ref([])
const products       = ref([])
const selectedCategory = ref(null)
const keyword        = ref('')
const pageNum        = ref(1)
const pageSize       = ref(12)
const total          = ref(0)

async function fetchProducts() {
  const res = await getProducts({ pageNum: pageNum.value, pageSize: pageSize.value,
    categoryId: selectedCategory.value || undefined, keyword: keyword.value || undefined })
  products.value = res.records
  total.value    = res.total
}

onMounted(async () => {
  categories.value = await getCategories()
  fetchProducts()
})
</script>
