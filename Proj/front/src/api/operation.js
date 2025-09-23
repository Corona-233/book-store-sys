import request from '@/utils/request'

// 操作记录相关 API
export const operationApi = {
  // 分页查询操作记录
  listPage: (data) => {
    return request.post('/operation/listPage', data)
  },

  // 保存操作记录
  save: (data) => {
    return request.post('/operation/save', data)
  },

  // 更新操作记录
  update: (data) => {
    return request.post('/operation/update', data)
  },

  // 删除操作记录
  delete: (id) => {
    return request.get(`/operation/del?id=${id}`)
  },

  // 获取所有仓库列表
  getStorageList: () => {
    return request.get('/storage/list')
  },

  // 获取所有商品类型列表
  getGoodsTypeList: () => {
    return request.get('/goodstype/list')
  },

  // 获取所有商品列表
  getGoodsList: () => {
    return request.get('/goods/list')
  }
}
