import request from './request'

export const getReviews = productId => request.get(`/review/product/${productId}`)
export const addReview  = data => request.post('/review', data)
