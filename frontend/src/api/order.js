import request from './request'

export const placeOrder   = data => request.post('/order', data)
export const getOrders    = (pageNum = 1, pageSize = 10) =>
  request.get('/order', { params: { pageNum, pageSize } })
export const getOrderItems = orderId => request.get(`/order/${orderId}/items`)
export const payOrder = orderId => request.post(`/order/${orderId}/pay`)
export const getAdminOrders = (pageNum = 1, pageSize = 10) =>
  request.get('/order/admin/page', { params: { pageNum, pageSize } })
export const updateStatus = data => request.put('/order/status', data)
