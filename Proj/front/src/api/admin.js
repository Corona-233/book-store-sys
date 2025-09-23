import request from '@/utils/request'

// 管理员相关 API
export const adminApi = {
  // 根据账号查找管理员
  findByNo: (no) => {
    return request.get(`/user/findByNo?no=${no}`)
  },

  // 分页查询管理员列表
  listPage: (data) => {
    return request.post('/user/listPage', data)
  },

  // 保存管理员
  save: (data) => {
    return request.post('/user/save', data)
  },

  // 更新管理员
  update: (data) => {
    return request.post('/user/update', data)
  },

  // 删除管理员
  delete: (id) => {
    return request.get(`/user/del?id=${id}`)
  }
}
