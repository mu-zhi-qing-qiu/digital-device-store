<template>
  <div>
    <el-button type="primary" @click="openDialog()" style="margin-bottom:16px">新增分类</el-button>
    <el-table :data="list" border>
      <el-table-column prop="id"       label="ID"   width="80" />
      <el-table-column prop="name"     label="分类名" />
      <el-table-column prop="parentId" label="父分类ID" width="120" />
      <el-table-column label="操作" width="160">
        <template #default="{ row }">
          <el-button link type="primary" @click="openDialog(row)">编辑</el-button>
          <el-button link type="danger"  @click="del(row.id)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-dialog v-model="show" :title="form.id ? '编辑分类' : '新增分类'" width="400px">
      <el-form :model="form" label-width="80px">
        <el-form-item label="分类名"><el-input v-model="form.name" /></el-form-item>
        <el-form-item label="父分类">
          <el-select v-model="form.parentId" placeholder="不选则为顶级" clearable>
            <el-option v-for="c in list" :key="c.id" :label="c.name" :value="c.id" />
          </el-select>
        </el-form-item>
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
import { getCategories, addCategory, updateCategory, deleteCategory } from '@/api/category'
import { ElMessageBox, ElMessage } from 'element-plus'

const list = ref([])
const show = ref(false)
const form = reactive({})

async function load() { list.value = await getCategories() }

function openDialog(row = {}) {
  Object.assign(form, { id: null, name: '', parentId: null, ...row })
  show.value = true
}

async function save() {
  form.id ? await updateCategory(form) : await addCategory(form)
  ElMessage.success('保存成功')
  show.value = false
  load()
}

async function del(id) {
  await ElMessageBox.confirm('确认删除？', '警告', { type: 'warning' })
  await deleteCategory(id)
  load()
}

onMounted(load)
</script>
