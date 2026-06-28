<template>
  <main class="page profile-page">
    <section class="lux-container profile">
      <div class="profile__hero panel">
        <div class="avatar">{{ initial }}</div>
        <div>
          <p class="eyebrow">个人中心</p>
          <h1>{{ store.user?.username || '数码会员' }}</h1>
          <p>{{ store.user?.email || '高端数码商城会员' }}</p>
        </div>
      </div>

      <div class="profile__grid">
        <div class="panel metric">
          <span>角色</span>
          <strong>{{ store.isAdmin ? '管理员' : '会员' }}</strong>
        </div>
        <div class="panel metric">
          <span>手机号</span>
          <strong>{{ store.user?.phone || '未设置' }}</strong>
        </div>
        <div class="panel metric">
          <span>体验等级</span>
          <strong>黑标会员</strong>
        </div>
      </div>

      <div class="actions">
        <LuxuryButton to="/orders">查看订单</LuxuryButton>
        <LuxuryButton variant="ghost" to="/cart">查看购物车</LuxuryButton>
      </div>
    </section>
  </main>
</template>

<script setup>
import { computed } from 'vue'
import { useUserStore } from '@/stores/user'
import LuxuryButton from '@/components/ui/LuxuryButton.vue'

const store = useUserStore()
const initial = computed(() => String(store.user?.username || 'U').slice(0, 1).toUpperCase())
</script>

<style scoped>
.profile {
  display: grid;
  gap: 24px;
  padding: 12vh 0 110px;
}

.profile__hero {
  display: flex;
  align-items: center;
  gap: 28px;
  padding: 34px;
}

.avatar {
  display: grid;
  width: 112px;
  height: 112px;
  place-items: center;
  border: 1px solid rgba(255, 255, 255, 0.22);
  border-radius: 50%;
  font-size: 46px;
  font-weight: 900;
}

h1 {
  margin: 8px 0;
  font-size: clamp(42px, 6vw, 72px);
}

p {
  margin: 0;
  color: #888;
}

.profile__grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 16px;
}

.metric {
  display: grid;
  gap: 16px;
  padding: 28px;
}

.metric span {
  color: #777;
  font-size: 12px;
  font-weight: 900;
  text-transform: uppercase;
}

.metric strong {
  font-size: 30px;
}

.actions {
  display: flex;
  gap: 14px;
}

@media (max-width: 760px) {
  .profile__hero,
  .actions {
    display: grid;
  }

  .profile__grid {
    grid-template-columns: 1fr;
  }
}
</style>

