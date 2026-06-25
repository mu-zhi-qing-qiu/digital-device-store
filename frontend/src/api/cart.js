import request from './request'

export const getCart   = userId => request.get(`/cart/${userId}`)
export const addToCart = data   => request.post('/cart', data)
export const removeFromCart = (userId, cartItemId) => request.delete(`/cart/${userId}/${cartItemId}`)
