<template>
  <div>
    <el-table :data="page.records" border>
      <el-table-column prop="id"       label="ID"  width="80" />
      <el-table-column prop="username" label="用户名" />
      <el-table-column prop="phone"    label="手机号" />
      <el-table-column prop="email"    label="邮箱" />
      <el-table-column prop="role"     label="角色" width="80">
        <template #default="{ row }">
          <el-tag :type="row.role===1?'danger':''">{{ row.role===1?'管理员':'用户' }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="100">
        <template #default="{ row }">
          <el-button link type="danger" @click="del(row.id)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination background layout="prev,pager,next" :total="page.total" :page-size="10"
      v-model:current-page="pageNum" @current-change="load" style="margin-top:12px" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getUsers, deleteUser } from '@/api/user'
import { ElMessageBox } from 'element-plus'

const page    = ref({})
const pageNum = ref(1)

async function load() { page.value = await getUsers(pageNum.value) }

async function del(id) {
  await ElMessageBox.confirm('确认删除该用户？', '警告', { type: 'warning' })
  await deleteUser(id)
  load()
}

onMounted(load)
</script>
