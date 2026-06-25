<template>
  <div style="display:flex;justify-content:center;align-items:center;height:100vh;background:#f5f7fa">
    <el-card style="width:400px">
      <h2 style="text-align:center;margin-bottom:24px">注册</h2>
      <el-form :model="form" @submit.prevent="submit">
        <el-form-item><el-input v-model="form.username" placeholder="用户名" /></el-form-item>
        <el-form-item><el-input v-model="form.password" type="password" placeholder="密码" show-password /></el-form-item>
        <el-form-item><el-input v-model="form.phone" placeholder="手机号（选填）" /></el-form-item>
        <el-form-item><el-input v-model="form.email" placeholder="邮箱（选填）" /></el-form-item>
        <el-button type="primary" style="width:100%" native-type="submit" :loading="loading">注册</el-button>
      </el-form>
      <div style="text-align:center;margin-top:12px">
        已有账号？<el-link type="primary" @click="router.push('/login')">去登录</el-link>
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import { register } from '@/api/user'
import { ElMessage } from 'element-plus'

const router  = useRouter()
const form    = reactive({ username: '', password: '', phone: '', email: '' })
const loading = ref(false)

async function submit() {
  loading.value = true
  try {
    await register(form)
    ElMessage.success('注册成功，请登录')
    router.push('/login')
  } finally {
    loading.value = false
  }
}
</script>
