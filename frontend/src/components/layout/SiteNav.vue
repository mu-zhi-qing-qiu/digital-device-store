<template>
  <header :class="['site-nav', { 'site-nav--solid': scrolled }]">
    <RouterLink class="site-nav__logo" to="/">
      <span>DS</span>
      <strong>数码臻选</strong>
    </RouterLink>

    <nav class="site-nav__links">
      <RouterLink to="/">首页</RouterLink>
      <RouterLink to="/products">产品</RouterLink>
      <RouterLink to="/cart">购物车</RouterLink>
      <RouterLink to="/orders">订单</RouterLink>
    </nav>

    <div class="site-nav__actions">
      <RouterLink class="icon-btn" to="/search" title="搜索">
        <Search :size="19" />
      </RouterLink>
      <RouterLink v-if="!store.isLoggedIn" class="account-link" to="/login">登录</RouterLink>
      <div v-else class="user-menu">
        <RouterLink class="avatar" to="/profile" title="个人中心">
          {{ avatarText }}
        </RouterLink>
        <button class="icon-btn" type="button" title="退出登录" @click="logout">
          <LogOut :size="18" />
        </button>
      </div>
    </div>
  </header>
</template>

<script setup>
import { computed, onMounted, onUnmounted, ref } from 'vue'
import { RouterLink, useRouter } from 'vue-router'
import { LogOut, Search } from '@lucide/vue'
import { useUserStore } from '@/stores/user'

const router = useRouter()
const store = useUserStore()
const scrolled = ref(false)

const avatarText = computed(() => String(store.user?.username || 'U').slice(0, 1).toUpperCase())

function onScroll() {
  scrolled.value = window.scrollY > 18
}

function logout() {
  store.logout()
  router.push('/login')
}

onMounted(() => {
  onScroll()
  window.addEventListener('scroll', onScroll, { passive: true })
})

onUnmounted(() => window.removeEventListener('scroll', onScroll))
</script>

<style scoped>
.site-nav {
  position: fixed;
  z-index: 50;
  top: 0;
  left: 0;
  right: 0;
  display: grid;
  height: var(--nav-height);
  grid-template-columns: 1fr auto 1fr;
  align-items: center;
  gap: 24px;
  border-bottom: 1px solid transparent;
  padding: 0 max(24px, calc((100vw - 1440px) / 2));
  background: rgba(0, 0, 0, 0.18);
  backdrop-filter: blur(18px);
  transition: background 240ms ease, border-color 240ms ease;
}

.site-nav--solid {
  border-bottom-color: rgba(255, 255, 255, 0.09);
  background: rgba(0, 0, 0, 0.74);
}

.site-nav__logo {
  display: inline-flex;
  width: max-content;
  align-items: center;
  gap: 12px;
}

.site-nav__logo span {
  display: grid;
  width: 34px;
  height: 34px;
  place-items: center;
  border: 1px solid rgba(255, 255, 255, 0.24);
  border-radius: 50%;
  font-size: 12px;
  font-weight: 900;
}

.site-nav__logo strong {
  font-size: 14px;
  font-weight: 800;
  letter-spacing: 0;
}

.site-nav__links {
  display: flex;
  align-items: center;
  gap: 30px;
}

.site-nav__links a {
  color: #aaa;
  font-size: 14px;
  transition: color 200ms ease;
}

.site-nav__links a:hover,
.site-nav__links a.router-link-active {
  color: #fff;
}

.site-nav__actions,
.user-menu {
  display: flex;
  align-items: center;
  justify-content: end;
  gap: 10px;
}

.icon-btn,
.avatar {
  display: grid;
  width: 40px;
  height: 40px;
  place-items: center;
  border: 1px solid rgba(255, 255, 255, 0.12);
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.04);
  color: #fff;
  cursor: pointer;
  transition: background 200ms ease, color 200ms ease, transform 200ms ease;
}

.icon-btn:hover,
.avatar:hover {
  transform: translateY(-2px);
  background: #fff;
  color: #000;
}

.account-link {
  display: inline-flex;
  height: 40px;
  align-items: center;
  border: 1px solid rgba(255, 255, 255, 0.18);
  border-radius: 999px;
  padding: 0 16px;
  color: #fff;
  font-size: 14px;
}

.avatar {
  font-size: 13px;
  font-weight: 900;
}

@media (max-width: 760px) {
  .site-nav {
    grid-template-columns: auto 1fr;
    padding: 0 14px;
  }

  .site-nav__links {
    display: none;
  }

  .site-nav__actions {
    gap: 8px;
  }

  .site-nav__logo strong {
    display: none;
  }
}
</style>
