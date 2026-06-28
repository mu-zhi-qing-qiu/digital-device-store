<template>
  <div class="empty-state">
    <div class="empty-state__mark">
      <slot name="icon">
        <CircleOff :size="28" />
      </slot>
    </div>
    <h2>{{ title }}</h2>
    <p>{{ text }}</p>
    <slot />
  </div>
</template>

<script setup>
import { CircleOff } from '@lucide/vue'

defineProps({
  title: { type: String, default: '暂无内容' },
  text: { type: String, default: '这里还没有可展示的信息。' }
})
</script>

<style scoped>
.empty-state {
  display: grid;
  min-height: 360px;
  place-items: center;
  align-content: center;
  gap: 16px;
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 28px;
  background: rgba(255, 255, 255, 0.035);
  text-align: center;
}

.empty-state__mark {
  display: grid;
  width: 64px;
  height: 64px;
  place-items: center;
  border: 1px solid rgba(255, 255, 255, 0.14);
  border-radius: 50%;
  color: #ddd;
}

h2 {
  margin: 0;
  font-size: 30px;
}

p {
  max-width: 420px;
  margin: 0;
  color: #888;
}
</style>

