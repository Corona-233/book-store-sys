import request from '@/utils/request'

// 用户相关 API
export const userApi = {
  // 用户登录
  login: (data) => {
    return request.post('/user/login', data)
  },

  // 根据账号查找用户
  findByNo: (no) => {
    return request.get(`/user/findByNo?no=${no}`)
  },

  // 分页查询用户列表
  listPage: (data) => {
    return request.post('/user/listPage', data)
  },

  // 保存用户
  save: (data) => {
    return request.post('/user/save', data)
  },

  // 更新用户
  update: (data) => {
    return request.post('/user/update', data)
  },

  // 删除用户
  delete: (id) => {
    return request.get(`/user/del?id=${id}`)
  }
}
