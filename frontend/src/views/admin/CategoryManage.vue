<template>
  <section class="admin-page">
    <div class="head">
      <div>
        <p class="eyebrow">管理端 / 分类</p>
        <h1>分类管理</h1>
      </div>
      <LuxuryButton @click="openDialog()">新增分类</LuxuryButton>
    </div>

    <div class="cards">
      <article v-for="item in list" :key="item.id" class="panel card">
        <span>分类 {{ item.id }}</span>
        <h2>{{ item.name }}</h2>
        <p>父级：{{ item.parentId || '根分类' }}</p>
        <div>
          <button type="button" @click="openDialog(item)">编辑</button>
          <button type="button" @click="del(item.id)">删除</button>
        </div>
      </article>
    </div>

    <div v-if="show" class="modal">
      <form class="dialog glass" @submit.prevent="save">
        <h2>{{ form.id ? '编辑分类' : '新增分类' }}</h2>
        <input v-model="form.name" class="lux-input" placeholder="分类名称" />
        <input v-model="form.parentId" class="lux-input" placeholder="父级 ID，可为空" />
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
import { getCategories, addCategory, updateCategory, deleteCategory } from '@/api/category'
import { ElMessageBox, ElMessage } from 'element-plus'
import LuxuryButton from '@/components/ui/LuxuryButton.vue'

const list = ref([])
const show = ref(false)
const form = reactive({})

async function load() {
  list.value = await getCategories()
}

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
  await ElMessageBox.confirm('确认删除该分类？', '警告', { type: 'warning' })
  await deleteCategory(id)
  load()
}

onMounted(load)
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
}

h1 {
  margin: 0;
  font-size: 52px;
}

.cards {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 16px;
}

.card {
  display: grid;
  gap: 14px;
  padding: 24px;
}

.card span,
.card p {
  margin: 0;
  color: #777;
}

.card h2 {
  margin: 0;
  font-size: 30px;
}

.card div,
.dialog__actions {
  display: flex;
  gap: 10px;
}

button {
  border: 1px solid rgba(255, 255, 255, 0.12);
  border-radius: 999px;
  background: transparent;
  color: #fff;
  padding: 9px 14px;
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
  width: min(100%, 480px);
  gap: 14px;
  border-radius: 28px;
  padding: 28px;
}

@media (max-width: 900px) {
  .cards {
    grid-template-columns: 1fr;
  }
}
</style>
