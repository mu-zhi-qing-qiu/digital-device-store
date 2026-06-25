<template>
  <el-container style="height:100vh">
    <el-aside width="200px" style="background:#304156">
      <div style="color:#fff;font-size:18px;padding:20px;font-weight:bold">管理后台</div>
      <el-menu router background-color="#304156" text-color="#bfcbd9" active-text-color="#409eff">
        <el-menu-item index="/admin/products"><el-icon><Goods /></el-icon>商品管理</el-menu-item>
        <el-menu-item index="/admin/categories"><el-icon><Grid /></el-icon>分类管理</el-menu-item>
        <el-menu-item index="/admin/users"><el-icon><User /></el-icon>用户管理</el-menu-item>
        <el-menu-item index="/admin/orders"><el-icon><List /></el-icon>订单管理</el-menu-item>
      </el-menu>
    </el-aside>
    <el-container direction="vertical">
      <el-header style="display:flex;align-items:center;justify-content:flex-end;border-bottom:1px solid #eee">
        <el-button link @click="router.push('/')">前台首页</el-button>
        <el-button link type="danger" @click="logout">退出</el-button>
      </el-header>
      <el-main><router-view /></el-main>
    </el-container>
  </el-container>
</template>

<script setup>
import { useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'
const router = useRouter()
const store  = useUserStore()
function logout() { store.logout(); router.push('/login') }
</script>
