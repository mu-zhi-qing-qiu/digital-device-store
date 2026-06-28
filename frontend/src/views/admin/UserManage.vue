<template>
  <section class="admin-page">
    <div class="head">
      <p class="eyebrow">管理端 / 用户</p>
      <h1>用户管理</h1>
    </div>

    <div class="table panel">
      <div class="row row--head">
        <span>ID</span>
        <span>用户名</span>
        <span>邮箱</span>
        <span>角色</span>
        <span>操作</span>
      </div>
      <div v-for="item in page.records || []" :key="item.id" class="row">
        <strong>{{ item.id }}</strong>
        <span>{{ item.username }}</span>
        <span>{{ item.email || '-' }}</span>
        <span>{{ item.role === 1 ? '管理员' : '会员' }}</span>
        <button type="button" @click="del(item.id)">删除</button>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getUsers, deleteUser } from '@/api/user'
import { ElMessageBox } from 'element-plus'

const page = ref({})
const pageNum = ref(1)

async function load() {
  page.value = await getUsers(pageNum.value)
}

async function del(id) {
  await ElMessageBox.confirm('确认删除该用户？', '警告', { type: 'warning' })
  await deleteUser(id)
  load()
}

onMounted(load)
</script>

<style scoped>
.admin-page {
  display: grid;
  gap: 24px;
}

h1 {
  margin: 8px 0 0;
  font-size: 52px;
}

.table {
  overflow: hidden;
}

.row {
  display: grid;
  grid-template-columns: 0.6fr 1fr 1.4fr 0.8fr 0.7fr;
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

button {
  border: 1px solid rgba(255, 255, 255, 0.12);
  border-radius: 999px;
  background: transparent;
  color: #fff;
  padding: 9px 14px;
  cursor: pointer;
}

@media (max-width: 860px) {
  .row {
    grid-template-columns: 1fr;
  }
}
</style>
