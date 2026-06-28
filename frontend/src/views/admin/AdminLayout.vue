<template>
  <div class="admin-shell">
    <aside class="admin-nav glass">
      <RouterLink class="brand" to="/">DS</RouterLink>
      <nav>
        <RouterLink to="/admin/products">产品</RouterLink>
        <RouterLink to="/admin/categories">分类</RouterLink>
        <RouterLink to="/admin/users">用户</RouterLink>
        <RouterLink to="/admin/orders">订单</RouterLink>
      </nav>
      <button type="button" @click="logout">退出登录</button>
    </aside>
    <main>
      <RouterView />
    </main>
  </div>
</template>

<script setup>
import { RouterLink, RouterView, useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'

const router = useRouter()
const store = useUserStore()

function logout() {
  store.logout()
  router.push('/login')
}
</script>

<style scoped>
.admin-shell {
  display: grid;
  min-height: 100vh;
  grid-template-columns: 240px 1fr;
  background: #000;
}

.admin-nav {
  position: sticky;
  top: 0;
  display: grid;
  height: 100vh;
  grid-template-rows: auto 1fr auto;
  gap: 28px;
  border-width: 0 1px 0 0;
  padding: 24px;
}

.brand {
  display: grid;
  width: 44px;
  height: 44px;
  place-items: center;
  border: 1px solid rgba(255, 255, 255, 0.22);
  border-radius: 50%;
  font-weight: 900;
}

nav {
  display: grid;
  align-content: start;
  gap: 10px;
}

nav a,
button {
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.04);
  color: #ddd;
  padding: 12px 16px;
  text-align: left;
}

nav a.router-link-active,
nav a:hover,
button:hover {
  background: #fff;
  color: #000;
}

button {
  cursor: pointer;
}

main {
  min-width: 0;
  padding: 36px;
}

@media (max-width: 820px) {
  .admin-shell {
    grid-template-columns: 1fr;
  }

  .admin-nav {
    position: relative;
    height: auto;
    border-width: 0 0 1px 0;
  }
}
</style>
