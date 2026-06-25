<template>
  <el-container direction="vertical" style="min-height:100vh">
    <el-header style="display:flex;align-items:center;justify-content:space-between;background:#409eff;color:#fff">
      <span style="font-size:20px;font-weight:bold;cursor:pointer" @click="router.push('/')">📱 数码设备商城</span>
      <div style="display:flex;gap:12px;align-items:center">
        <el-button v-if="!store.isLoggedIn" type="primary" bg @click="router.push('/login')">登录</el-button>
        <template v-else>
          <el-button link style="color:#fff" @click="router.push('/cart')">
            <el-icon><ShoppingCart /></el-icon> 购物车
          </el-button>
          <el-button link style="color:#fff" @click="router.push('/orders')">我的订单</el-button>
          <el-button v-if="store.isAdmin" link style="color:#fff" @click="router.push('/admin')">管理后台</el-button>
          <el-dropdown @command="handleCmd">
            <span style="color:#fff;cursor:pointer">{{ store.user.username }} ▾</span>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item command="logout">退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </template>
      </div>
    </el-header>
    <el-main><router-view /></el-main>
  </el-container>
</template>

<script setup>
import { useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'
const router = useRouter()
const store  = useUserStore()
function handleCmd(cmd) {
  if (cmd === 'logout') { store.logout(); router.push('/login') }
}
</script>
