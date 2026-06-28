<template>
  <main class="auth-page">
    <div class="cinematic-grid" />
    <section class="auth-card glass">
      <RouterLink class="brand" to="/">DS</RouterLink>
      <p class="eyebrow">账户</p>
      <h1>登录数码臻选</h1>
      <form @submit.prevent="submit">
        <input v-model="form.username" class="lux-input" placeholder="用户名" autocomplete="username" />
        <input v-model="form.password" class="lux-input" placeholder="密码" type="password" autocomplete="current-password" />
        <LuxuryButton block type="submit">{{ loading ? '登录中...' : '登录' }}</LuxuryButton>
      </form>
      <p class="switch">还没有账号？<RouterLink to="/register">创建账号</RouterLink></p>
    </section>
  </main>
</template>

<script setup>
import { reactive, ref } from 'vue'
import { RouterLink, useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { login } from '@/api/user'
import LuxuryButton from '@/components/ui/LuxuryButton.vue'

const router = useRouter()
const store = useUserStore()
const form = reactive({ username: '', password: '' })
const loading = ref(false)

async function submit() {
  loading.value = true
  try {
    const auth = await login(form)
    store.setUser(auth)
    router.push(store.isAdmin ? '/admin' : '/')
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
  width: min(100%, 460px);
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
