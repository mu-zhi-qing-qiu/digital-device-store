import request from './request'

export const getCategories = parentId => request.get('/category', { params: parentId != null ? { parentId } : {} })
export const addCategory    = data => request.post('/category', data)
export const updateCategory = data => request.put('/category', data)
export const deleteCategory = id => request.delete(`/category/${id}`)
