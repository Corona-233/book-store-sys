import request from '@/utils/request'

// 商品类型相关 API
export const goodstypeApi = {
  // 分页查询商品类型列表
  listPage: (data) => {
    return request.post('/goodstype/listPage', data)
  },

  // 获取所有商品类型列表
  list: () => {
    return request.get('/goodstype/list')
  },

  // 保存商品类型
  save: (data) => {
    return request.post('/goodstype/save', data)
  },

  // 更新商品类型
  update: (data) => {
    return request.post('/goodstype/update', data)
  },

  // 删除商品类型
  delete: (id) => {
    return request.get(`/goodstype/del?id=${id}`)
  }
}
