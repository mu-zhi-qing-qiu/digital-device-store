<template>
  <div style="max-width:900px;margin:30px auto;padding:0 20px">
    <h2>我的购物车</h2>
    <el-empty v-if="!items.length" description="购物车是空的" />
    <el-table v-else :data="items" style="margin-bottom:16px">
      <el-table-column prop="productId" label="商品ID" width="100" />
      <el-table-column prop="quantity"  label="数量" width="100" />
      <el-table-column label="操作" width="100">
        <template #default="{ row }">
          <el-button type="danger" link @click="remove(row.id)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-button v-if="items.length" type="primary" @click="checkout">提交订单</el-button>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useUserStore } from '@/stores/user'
import { useRouter } from 'vue-router'
import { getCart, removeFromCart } from '@/api/cart'
import { placeOrder } from '@/api/order'
import { ElMessage } from 'element-plus'

const store  = useUserStore()
const router = useRouter()
const items  = ref([])

async function load() { items.value = await getCart(store.user.id) }

async function remove(id) {
  await removeFromCart(store.user.id, id)
  load()
}

async function checkout() {
  await placeOrder({ userId: store.user.id, items: items.value.map(i => ({ productId: i.productId, quantity: i.quantity })) })
  ElMessage.success('下单成功')
  router.push('/orders')
}

onMounted(load)
</script>
