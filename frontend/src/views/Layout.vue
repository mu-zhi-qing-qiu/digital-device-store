<template>
  <div class="app-shell">
    <SiteNav />
    <RouterView />
  </div>
</template>

<script setup>
import { RouterView } from 'vue-router'
import SiteNav from '@/components/layout/SiteNav.vue'
</script>

