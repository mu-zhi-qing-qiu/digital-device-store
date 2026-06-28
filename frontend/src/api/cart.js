import request from './request'

export const getCart   = () => request.get('/cart')
export const addToCart = data   => request.post('/cart', data)
export const removeFromCart = cartItemId => request.delete(`/cart/${cartItemId}`)
