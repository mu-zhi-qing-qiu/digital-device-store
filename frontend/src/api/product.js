import request from './request'

export const getProducts = params => request.get('/product', { params })
export const getProduct  = id => request.get(`/product/${id}`)
export const getImages   = id => request.get(`/product/${id}/images`)
export const addProduct    = data => request.post('/product', data)
export const updateProduct = data => request.put('/product', data)
export const deleteProduct = id => request.delete(`/product/${id}`)
