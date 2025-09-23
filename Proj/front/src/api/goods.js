import request from '@/utils/request'

// 商品/书籍相关 API
export const goodsApi = {
  // 分页查询商品列表
  listPage: (data) => {
    return request.post('/goods/listPage', data)
  },

  // 保存商品
  save: (data) => {
    return request.post('/goods/save', data)
  },

  // 更新商品
  update: (data) => {
    return request.post('/goods/update', data)
  },

  // 删除商品
  delete: (id) => {
    return request.get(`/goods/del?id=${id}`)
  },

  // 获取所有仓库列表
  getStorageList: () => {
    return request.get('/storage/list')
  },

  // 获取所有商品类型列表
  getGoodsTypeList: () => {
    return request.get('/goodstype/list')
  }
}
