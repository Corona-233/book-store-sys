import request from '@/utils/request'

// 仓库相关 API
export const storageApi = {
  // 分页查询仓库列表
  listPage: (data) => {
    return request.post('/storage/listPage', data)
  },

  // 获取所有仓库列表
  list: () => {
    return request.get('/storage/list')
  },

  // 保存仓库
  save: (data) => {
    return request.post('/storage/save', data)
  },

  // 更新仓库
  update: (data) => {
    return request.post('/storage/update', data)
  },

  // 删除仓库
  delete: (id) => {
    return request.get(`/storage/del?id=${id}`)
  }
}
