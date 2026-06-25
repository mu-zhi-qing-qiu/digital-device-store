import request from './request'

export const register = data => request.post('/user/register', data)
export const login    = data => request.post('/user/login', data)
export const getUsers = (pageNum = 1, pageSize = 10) => request.get('/user/page', { params: { pageNum, pageSize } })
export const deleteUser = id => request.delete(`/user/${id}`)
