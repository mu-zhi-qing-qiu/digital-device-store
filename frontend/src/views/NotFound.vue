<template>
  <main class="not-found">
    <div class="cinematic-grid" />
    <section class="lux-container not-found__inner">
      <p class="eyebrow">404</p>
      <h1 class="display-title">这个页面还未发布。</h1>
      <p class="body-large">回到产品体验主线，继续探索高端数码设备。</p>
      <LuxuryButton to="/">返回首页</LuxuryButton>
    </section>
  </main>
</template>

<script setup>
import LuxuryButton from '@/components/ui/LuxuryButton.vue'
</script>

<style scoped>
.not-found {
  position: relative;
  display: grid;
  min-height: 100vh;
  place-items: center;
  overflow: hidden;
  background: #000;
}

.not-found__inner {
  position: relative;
  z-index: 1;
  display: grid;
  max-width: 820px;
  justify-items: start;
  gap: 24px;
}
</style>
