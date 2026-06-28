import { createRouter, createWebHistory } from 'vue-router'
import { useUserStore } from '@/stores/user'

const routes = [
  { path: '/login',    component: () => import('@/views/Login.vue') },
  { path: '/register', component: () => import('@/views/Register.vue') },
  {
    path: '/',
    component: () => import('@/views/Layout.vue'),
    children: [
      { path: '',              component: () => import('@/views/Home.vue') },
      { path: 'products',      component: () => import('@/views/ProductList.vue') },
      { path: 'search',        component: () => import('@/views/Search.vue') },
      { path: 'product/:id',  component: () => import('@/views/ProductDetail.vue') },
      { path: 'cart',         component: () => import('@/views/Cart.vue'),      meta: { auth: true } },
      { path: 'checkout',     component: () => import('@/views/Checkout.vue'),  meta: { auth: true } },
      { path: 'orders',       component: () => import('@/views/OrderList.vue'), meta: { auth: true } },
      { path: 'profile',      component: () => import('@/views/Profile.vue'),   meta: { auth: true } },
    ]
  },
  {
    path: '/admin',
    component: () => import('@/views/admin/AdminLayout.vue'),
    meta: { auth: true, admin: true },
    children: [
      { path: '',         redirect: '/admin/products' },
      { path: 'products', component: () => import('@/views/admin/ProductManage.vue') },
      { path: 'categories', component: () => import('@/views/admin/CategoryManage.vue') },
      { path: 'users',    component: () => import('@/views/admin/UserManage.vue') },
      { path: 'orders',   component: () => import('@/views/admin/OrderManage.vue') },
    ]
  },
  { path: '/:pathMatch(.*)*', component: () => import('@/views/NotFound.vue') }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach(to => {
  const store = useUserStore()
  if (to.meta.auth && !store.isLoggedIn) return '/login'
  if (to.meta.admin && !store.isAdmin)   return '/'
})

export default router
