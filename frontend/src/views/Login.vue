<template>
  <div style="display:flex;justify-content:center;align-items:center;height:100vh;background:#f5f7fa">
    <el-card style="width:380px">
      <h2 style="text-align:center;margin-bottom:24px">登录</h2>
      <el-form :model="form" @submit.prevent="submit">
        <el-form-item><el-input v-model="form.username" placeholder="用户名" prefix-icon="User" /></el-form-item>
        <el-form-item><el-input v-model="form.password" type="password" placeholder="密码" prefix-icon="Lock" show-password /></el-form-item>
        <el-button type="primary" style="width:100%" native-type="submit" :loading="loading">登录</el-button>
      </el-form>
      <div style="text-align:center;margin-top:12px">
        没有账号？<el-link type="primary" @click="router.push('/register')">立即注册</el-link>
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { login } from '@/api/user'

const router  = useRouter()
const store   = useUserStore()
const form    = reactive({ username: '', password: '' })
const loading = ref(false)

async function submit() {
  loading.value = true
  try {
    const user = await login(form)
    store.setUser(user)
    router.push(store.isAdmin ? '/admin' : '/')
  } finally {
    loading.value = false
  }
}
</script>
