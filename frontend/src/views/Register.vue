<template>
  <main class="auth-page">
    <div class="cinematic-grid" />
    <section class="auth-card glass">
      <RouterLink class="brand" to="/">DS</RouterLink>
      <p class="eyebrow">创建账户</p>
      <h1>加入黑标科技体验。</h1>
      <form @submit.prevent="submit">
        <input v-model="form.username" class="lux-input" placeholder="用户名" autocomplete="username" />
        <input v-model="form.password" class="lux-input" placeholder="密码" type="password" autocomplete="new-password" />
        <input v-model="form.phone" class="lux-input" placeholder="手机号" />
        <input v-model="form.email" class="lux-input" placeholder="邮箱" type="email" />
        <LuxuryButton block type="submit">{{ loading ? '创建中...' : '注册' }}</LuxuryButton>
      </form>
      <p class="switch">已有账号？<RouterLink to="/login">登录</RouterLink></p>
    </section>
  </main>
</template>

<script setup>
import { reactive, ref } from 'vue'
import { RouterLink, useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { register } from '@/api/user'
import { ElMessage } from 'element-plus'
import LuxuryButton from '@/components/ui/LuxuryButton.vue'

const router = useRouter()
const store = useUserStore()
const form = reactive({ username: '', password: '', phone: '', email: '' })
const loading = ref(false)

async function submit() {
  loading.value = true
  try {
    const auth = await register(form)
    store.setUser(auth)
    ElMessage.success('注册成功')
    router.push('/')
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.auth-page {
  position: relative;
  display: grid;
  min-height: 100vh;
  place-items: center;
  overflow: hidden;
  background: #000;
  padding: 24px;
}

.auth-card {
  position: relative;
  z-index: 1;
  display: grid;
  width: min(100%, 500px);
  gap: 20px;
  border-radius: 30px;
  padding: 34px;
}

.brand {
  display: grid;
  width: 46px;
  height: 46px;
  place-items: center;
  border: 1px solid rgba(255, 255, 255, 0.22);
  border-radius: 50%;
  font-weight: 900;
}

h1 {
  margin: 0;
  font-size: 42px;
  line-height: 1;
}

form {
  display: grid;
  gap: 14px;
}

.switch {
  margin: 0;
  color: #888;
}

.switch a {
  color: #fff;
}
</style>
