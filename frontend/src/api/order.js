import request from './request'

export const placeOrder   = data => request.post('/order', data)
export const getOrders    = (userId, pageNum = 1, pageSize = 10) =>
  request.get(`/order/${userId}`, { params: { pageNum, pageSize } })
export const updateStatus = data => request.put('/order/status', data)
