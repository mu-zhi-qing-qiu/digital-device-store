<template>
  <component
    :is="to ? RouterLink : 'button'"
    :to="to"
    :type="to ? undefined : type"
    :class="['lux-button', `lux-button--${variant}`, { 'lux-button--block': block }]"
    @click="$emit('click', $event)"
  >
    <span class="lux-button__ripple" />
    <span class="lux-button__content">
      <slot />
    </span>
  </component>
</template>

<script setup>
import { RouterLink } from 'vue-router'

defineProps({
  to: { type: [String, Object], default: '' },
  type: { type: String, default: 'button' },
  variant: { type: String, default: 'primary' },
  block: { type: Boolean, default: false }
})

defineEmits(['click'])
</script>

<style scoped>
.lux-button {
  position: relative;
  isolation: isolate;
  display: inline-flex;
  min-height: 48px;
  align-items: center;
  justify-content: center;
  gap: 10px;
  overflow: hidden;
  border: 1px solid rgba(255, 255, 255, 0.24);
  border-radius: 999px;
  padding: 0 24px;
  cursor: pointer;
  transition: transform 220ms ease, border-color 220ms ease, background 220ms ease, color 220ms ease;
}

.lux-button--block {
  width: 100%;
}

.lux-button__ripple {
  position: absolute;
  inset: auto auto 50% 50%;
  width: 0;
  height: 0;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.22);
  transform: translate(-50%, 50%);
  transition: width 520ms ease, height 520ms ease;
  z-index: -1;
}

.lux-button:hover .lux-button__ripple {
  width: 260px;
  height: 260px;
}

.lux-button__content {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  font-size: 14px;
  font-weight: 750;
}

.lux-button:hover {
  transform: translateY(-2px);
}

.lux-button--primary {
  background: #fff;
  color: #000;
}

.lux-button--primary:hover {
  background: #000;
  color: #fff;
  border-color: #fff;
}

.lux-button--ghost {
  background: rgba(255, 255, 255, 0.04);
  color: #fff;
}

.lux-button--ghost:hover {
  background: #fff;
  color: #000;
}

.lux-button--dark {
  background: #000;
  color: #fff;
}

.lux-button--dark:hover {
  background: #fff;
  color: #000;
}
</style>

