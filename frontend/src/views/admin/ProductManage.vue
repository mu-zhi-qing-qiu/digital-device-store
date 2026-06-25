<template>
  <div>
    <el-button type="primary" @click="openDialog()" style="margin-bottom:16px">新增商品</el-button>
    <el-table :data="page.records" border>
      <el-table-column prop="id"    label="ID"   width="80" />
      <el-table-column prop="name"  label="商品名" />
      <el-table-column prop="price" label="价格" width="100"><template #default="{row}">¥{{ row.price }}</template></el-table-column>
      <el-table-column prop="stock" label="库存" width="80" />
      <el-table-column prop="brand" label="品牌" width="100" />
      <el-table-column label="操作" width="160">
        <template #default="{ row }">
          <el-button link type="primary" @click="openDialog(row)">编辑</el-button>
          <el-button link type="danger"  @click="del(row.id)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination background layout="prev,pager,next" :total="page.total" :page-size="10"
      v-model:current-page="pageNum" @current-change="load" style="margin-top:12px" />

    <el-dialog v-model="show" :title="form.id ? '编辑商品' : '新增商品'" width="500px">
      <el-form :model="form" label-width="80px">
        <el-form-item label="商品名"><el-input v-model="form.name" /></el-form-item>
        <el-form-item label="价格"><el-input-number v-model="form.price" :precision="2" :min="0" /></el-form-item>
        <el-form-item label="库存"><el-input-number v-model="form.stock" :min="0" /></el-form-item>
        <el-form-item label="品牌"><el-input v-model="form.brand" /></el-form-item>
        <el-form-item label="分类">
          <el-select v-model="form.categoryId" placeholder="选择分类">
            <el-option v-for="c in categories" :key="c.id" :label="c.name" :value="c.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="描述"><el-input v-model="form.description" type="textarea" /></el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="show=false">取消</el-button>
        <el-button type="primary" @click="save">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { getProducts, addProduct, updateProduct, deleteProduct } from '@/api/product'
import { getCategories } from '@/api/category'
import { ElMessageBox, ElMessage } from 'element-plus'

const page       = ref({})
const pageNum    = ref(1)
const categories = ref([])
const show       = ref(false)
const form       = reactive({})

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
  await ElMessageBox.confirm('确认删除？', '警告', { type: 'warning' })
  await deleteProduct(id)
  load()
}

onMounted(async () => {
  categories.value = await getCategories()
  load()
})
</script>
