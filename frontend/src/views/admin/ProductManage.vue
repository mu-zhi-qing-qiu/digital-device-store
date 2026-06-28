<template>
  <section class="admin-page">
    <div class="head">
      <div>
        <p class="eyebrow">管理端 / 产品</p>
        <h1>产品管理</h1>
      </div>
      <LuxuryButton @click="openDialog()">新增产品</LuxuryButton>
    </div>

    <div class="table panel">
      <div class="row row--head">
        <span>名称</span>
        <span>品牌</span>
        <span>价格</span>
        <span>库存</span>
        <span>操作</span>
      </div>
      <div v-for="item in page.records || []" :key="item.id" class="row">
        <strong>{{ item.name }}</strong>
        <span>{{ item.brand || '-' }}</span>
        <span>{{ money(item.price) }}</span>
        <span>{{ item.stock }}</span>
        <div class="actions">
          <button type="button" @click="openDialog(item)">编辑</button>
          <button type="button" @click="del(item.id)">删除</button>
        </div>
      </div>
    </div>

    <el-pagination
      v-if="page.total > 10"
      v-model:current-page="pageNum"
      :total="page.total"
      :page-size="10"
      layout="prev, pager, next"
      @current-change="load"
    />

    <div v-if="show" class="modal">
      <form class="dialog glass" @submit.prevent="save">
        <h2>{{ form.id ? '编辑产品' : '新增产品' }}</h2>
        <input v-model="form.name" class="lux-input" placeholder="产品名称" />
        <input v-model="form.brand" class="lux-input" placeholder="品牌" />
        <input v-model.number="form.price" class="lux-input" placeholder="价格" type="number" />
        <input v-model.number="form.stock" class="lux-input" placeholder="库存" type="number" />
        <select v-model="form.categoryId" class="lux-select">
          <option :value="null">选择分类</option>
          <option v-for="category in categories" :key="category.id" :value="category.id">{{ category.name }}</option>
        </select>
        <textarea v-model="form.description" class="lux-textarea" placeholder="描述" />
        <div class="dialog__actions">
          <LuxuryButton variant="ghost" @click="show = false">取消</LuxuryButton>
          <LuxuryButton type="submit">保存</LuxuryButton>
        </div>
      </form>
    </div>
  </section>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { getProducts, addProduct, updateProduct, deleteProduct } from '@/api/product'
import { getCategories } from '@/api/category'
import { ElMessageBox, ElMessage } from 'element-plus'
import LuxuryButton from '@/components/ui/LuxuryButton.vue'
import { money } from '@/utils/format'

const page = ref({})
const pageNum = ref(1)
const categories = ref([])
const show = ref(false)
const form = reactive({})

async function load() {
  page.value = await getProducts({ pageNum: pageNum.value, pageSize: 10 })
}

function openDialog(row = {}) {
  Object.assign(form, { id: null, name: '', price: 0, stock: 0, brand: '', categoryId: null, description: '', ...row })
  show.value = true
}

async function save() {
  form.id ? await updateProduct(form) : await addProduct(form)
  ElMessage.success('保存成功')
  show.value = false
  load()
}

async function del(id) {
  await ElMessageBox.confirm('确认删除该产品？', '警告', { type: 'warning' })
  await deleteProduct(id)
  load()
}

onMounted(async () => {
  categories.value = await getCategories()
  load()
})
</script>

<style scoped>
.admin-page {
  display: grid;
  gap: 24px;
}

.head {
  display: flex;
  align-items: end;
  justify-content: space-between;
  gap: 20px;
}

h1,
h2 {
  margin: 0;
}

h1 {
  font-size: 52px;
}

.table {
  overflow: hidden;
}

.row {
  display: grid;
  grid-template-columns: 2fr 1fr 1fr 0.7fr 1fr;
  align-items: center;
  gap: 16px;
  border-top: 1px solid rgba(255, 255, 255, 0.08);
  padding: 18px 22px;
}

.row--head {
  border-top: 0;
  color: #777;
  font-size: 12px;
  font-weight: 900;
  letter-spacing: 0.12em;
  text-transform: uppercase;
}

.actions {
  display: flex;
  gap: 8px;
}

.actions button {
  border: 1px solid rgba(255, 255, 255, 0.12);
  border-radius: 999px;
  background: transparent;
  color: #fff;
  padding: 8px 12px;
  cursor: pointer;
}

.modal {
  position: fixed;
  z-index: 100;
  inset: 0;
  display: grid;
  place-items: center;
  background: rgba(0, 0, 0, 0.72);
  padding: 24px;
}

.dialog {
  display: grid;
  width: min(100%, 560px);
  gap: 14px;
  border-radius: 28px;
  padding: 28px;
}

.dialog__actions {
  display: flex;
  justify-content: end;
  gap: 12px;
}

@media (max-width: 860px) {
  .row {
    grid-template-columns: 1fr;
  }
}
</style>
