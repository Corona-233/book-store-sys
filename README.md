# 接口约定

## 项目概述

本项目是一个基于 Spring Boot + Vue.js 的库存管理系统，提供用户管理、商品管理、商品类型管理、仓库管理、操作记录等功能。

### 基础信息
- **基础URL**: `http://localhost:8090`
- **数据格式**: JSON

## 通用响应格式

所有接口都遵循统一的响应格式：

```json
{
  "code": 200,        // 状态码：200-成功，400-失败
  "msg": "成功",       // 状态信息
  "total": 0,         // 总记录数（分页时使用）
  "data": null        // 响应数据
}
```

## 分页查询参数格式

分页查询接口统一使用以下参数格式：

```json
{
  "pageNum": 1,       // 当前页码，默认1
  "pageSize": 20,     // 每页条数，默认20
  "param": {          // 查询条件
    "name": "商品名称",
    "storage": "仓库ID",
    "goodstype": "商品类型ID"
  }
}
```

---

## 1. 用户管理模块

### 1.1 用户登录
**接口地址**: `POST /user/login`

**请求参数**:
```json
{
  "no": "admin",      // 用户账号
  "password": "123456" // 密码
}
```

**响应示例**:
```json
{
  "code": 200,
  "msg": "成功",
  "total": 0,
  "data": {
    "user": {
      "id": 1,
      "no": "admin",
      "name": "管理员",
      "password": "123456",
      "age": 25,
      "sex": 1,
      "roleId": 1,
      "phone": "13800138000",
      "isValid": "1"
    },
    "menu": [
      {
        "id": 1,
        "menucode": "001",
        "menuname": "用户管理",
        "menulevel": "1",
        "menuparentcode": "0",
        "menuclick": "/user",
        "menuright": "1",
        "menucomponent": "UserManage",
        "menuicon": "el-icon-user"
      }
    ]
  }
}
```

### 1.2 获取用户列表
**接口地址**: `GET /user/list`

**响应示例**:
```json
{
  "code": 200,
  "msg": "成功",
  "total": 0,
  "data": [
    {
      "id": 1,
      "no": "admin",
      "name": "管理员",
      "password": "123456",
      "age": 25,
      "sex": 1,
      "roleId": 1,
      "phone": "13800138000",
      "isValid": "1"
    }
  ]
}
```

### 1.3 分页查询用户
**接口地址**: `POST /user/listPage`

**请求参数**:
```json
{
  "pageNum": 1,
  "pageSize": 20,
  "param": {
    "name": "管理员",    // 按姓名查询（模糊匹配）
    "sex": "1",         // 按性别查询：1-男，0-女
    "roleId": "1"       // 按权限查询
  }
}
```

### 1.4 新增用户
**接口地址**: `POST /user/save`

**请求参数**:
```json
{
  "no": "user001",
  "name": "张三",
  "password": "123456",
  "age": 25,
  "sex": 1,
  "roleId": 2,
  "phone": "13800138000",
  "isValid": "1"
}
```

### 1.5 修改用户
**接口地址**: `POST /user/update`

**请求参数**:
```json
{
  "id": 1,
  "no": "admin",
  "name": "管理员",
  "password": "123456",
  "age": 26,
  "sex": 1,
  "roleId": 1,
  "phone": "13800138000",
  "isValid": "1"
}
```

### 1.6 删除用户
**接口地址**: `GET /user/del`

**请求参数**: `id` (用户ID)

**示例**: `/user/del?id=1`

### 1.7 验证账号唯一性
**接口地址**: `GET /user/findByNo`

**请求参数**: `no` (用户账号)

**示例**: `/user/findByNo?no=admin`

---

## 2. 商品管理模块

### 2.1 分页查询商品
**接口地址**: `POST /goods/listPage`

**请求参数**:
```json
{
  "pageNum": 1,
  "pageSize": 20,
  "param": {
    "name": "商品名称",     // 按商品名称查询（模糊匹配）
    "storage": "1",        // 按仓库ID查询
    "goodstype": "1"       // 按商品类型ID查询
  }
}
```

**响应示例**:
```json
{
  "code": 200,
  "msg": "成功",
  "total": 100,
  "data": [
    {
      "id": 1,
      "name": "商品A",
      "storage": 1,
      "goodstype": 1,
      "count": 50,
      "remark": "商品描述"
    }
  ]
}
```

### 2.2 新增商品
**接口地址**: `POST /goods/save`

**请求参数**:
```json
{
  "name": "商品A",
  "storage": 1,          // 仓库ID
  "goodstype": 1,        // 商品类型ID
  "count": 50,           // 库存数量
  "remark": "商品描述"
}
```

### 2.3 修改商品
**接口地址**: `POST /goods/update`

**请求参数**:
```json
{
  "id": 1,
  "name": "商品A",
  "storage": 1,
  "goodstype": 1,
  "count": 60,
  "remark": "商品描述"
}
```

### 2.4 删除商品
**接口地址**: `GET /goods/del`

**请求参数**: `id` (商品ID)

**示例**: `/goods/del?id=1`

### 2.5 获取商品名称建议
**接口地址**: `GET /goods/nameSuggestions`

**请求参数**: `keyword` (关键词)

**示例**: `/goods/nameSuggestions?keyword=商品`

**响应示例**:
```json
{
  "code": 200,
  "msg": "成功",
  "total": 0,
  "data": ["商品A", "商品B"]
}
```

### 2.6 获取商品类型映射关系
**接口地址**: `GET /goods/typeMapping`

**响应示例**:
```json
{
  "code": 200,
  "msg": "成功",
  "total": 0,
  "data": {
    "商品A": "电子产品",
    "商品B": "服装"
  }
}
```

---

## 3. 商品类型管理模块

### 3.1 获取所有商品类型
**接口地址**: `GET /goodstype/list`

**响应示例**:
```json
{
  "code": 200,
  "msg": "成功",
  "total": 0,
  "data": [
    {
      "id": 1,
      "name": "电子产品",
      "remark": "电子设备相关商品"
    },
    {
      "id": 2,
      "name": "服装",
      "remark": "服装类商品"
    }
  ]
}
```

### 3.2 分页查询商品类型
**接口地址**: `POST /goodstype/listPage`

**请求参数**:
```json
{
  "pageNum": 1,
  "pageSize": 20,
  "param": {
    "name": "技术"        // 按类型名称查询（模糊匹配）
  }
}
```

### 3.3 新增商品类型
**接口地址**: `POST /goodstype/save`

**请求参数**:
```json
{
  "name": "食品",
  "remark": "食品类商品"
}
```

### 3.4 修改商品类型
**接口地址**: `POST /goodstype/update`

**请求参数**:
```json
{
  "id": 1,
  "name": "电子产品",
  "remark": "电子设备相关商品"
}
```

### 3.5 删除商品类型
**接口地址**: `GET /goodstype/del`

**请求参数**: `id` (商品类型ID)

**示例**: `/goodstype/del?id=1`

---

## 4. 仓库管理模块

### 4.1 获取所有仓库
**接口地址**: `GET /storage/list`

**响应示例**:
```json
{
  "code": 200,
  "msg": "成功",
  "total": 0,
  "data": [
    {
      "id": 1,
      "name": "主仓库",
      "remark": "主要存储仓库"
    },
    {
      "id": 2,
      "name": "备用仓库",
      "remark": "备用存储仓库"
    }
  ]
}
```

### 4.2 分页查询仓库
**接口地址**: `POST /storage/listPage`

**请求参数**:
```json
{
  "pageNum": 1,
  "pageSize": 20,
  "param": {
    "name": "主"         // 按仓库名称查询（模糊匹配）
  }
}
```

### 4.3 新增仓库
**接口地址**: `POST /storage/save`

**请求参数**:
```json
{
  "name": "仓库C",
  "remark": "新建仓库"
}
```

### 4.4 修改仓库
**接口地址**: `POST /storage/update`

**请求参数**:
```json
{
  "id": 1,
  "name": "主仓库",
  "remark": "主要存储仓库"
}
```

### 4.5 删除仓库
**接口地址**: `GET /storage/del`

**请求参数**: `id` (仓库ID)

**示例**: `/storage/del?id=1`

---

## 5. 操作记录模块

### 5.1 分页查询操作记录
**接口地址**: `POST /operation/listPage`

**请求参数**:
```json
{
  "pageNum": 1,
  "pageSize": 20,
  "param": {
    "no": "OP001",         // 按订单号查询（模糊匹配）
    "storage": "1",        // 按仓库ID查询
    "good": "Java",        // 按商品名称查询（模糊匹配）
    "goodstype": "1",      // 按商品类型ID查询
    "type": "0"            // 按操作类型查询：0-入库，1-出库
  }
}
```

**响应示例**:
```json
{
  "code": 200,
  "msg": "成功",
  "total": 50,
  "data": [
    {
      "id": 1,
      "no": "OP001",
      "good": "商品A",
      "goodstype": 1,
      "count": 10,
      "storage": 1,
      "type": "0"           // 0-入库，1-出库
    }
  ]
}
```

### 5.2 新增操作记录
**接口地址**: `POST /operation/save`

**请求参数**:
```json
{
  "no": "OP001",
  "good": "商品A",
  "goodstype": 1,
  "count": 10,
  "storage": 1,
  "type": "0"              // 0-入库，1-出库
}
```

**业务逻辑说明**:
- **入库操作** (`type: "0"`): 增加商品库存数量
- **出库操作** (`type: "1"`): 减少商品库存数量，需要检查库存是否充足
- 如果商品不存在且为入库操作，会自动创建新商品
- 如果商品不存在且为出库操作，会返回失败

### 5.3 修改操作记录
**接口地址**: `POST /operation/update`

**请求参数**:
```json
{
  "id": 1,
  "no": "OP001",
  "good": "商品A",
  "goodstype": 1,
  "count": 15,             // 修改数量
  "storage": 1,
  "type": "0"
}
```

**业务逻辑说明**:
- 修改操作会先回滚原操作对库存的影响，再应用新操作
- 出库修改：`当前库存 - (新出库数量 - 原出库数量)`
- 入库修改：`当前库存 + (新入库数量 - 原入库数量)`

### 5.4 删除操作记录
**接口地址**: `GET /operation/del`

**请求参数**: `id` (操作记录ID)

**示例**: `/operation/del?id=1`

**业务逻辑说明**:
- 删除操作会回滚对库存的影响
- 出库删除：将商品数量加上操作数量（回滚出库操作）
- 入库删除：将商品数量减去操作数量（回滚入库操作）

---

## 6. 菜单管理模块

### 6.1 根据角色获取菜单
**接口地址**: `GET /menu/list`

**请求参数**: `roleId` (角色ID)

**示例**: `/menu/list?roleId=1`

**响应示例**:
```json
{
  "code": 200,
  "msg": "成功",
  "total": 0,
  "data": [
    {
      "id": 1,
      "menucode": "001",
      "menuname": "用户管理",
      "menulevel": "1",
      "menuparentcode": "0",
      "menuclick": "/user",
      "menuright": "1",
      "menucomponent": "UserManage",
      "menuicon": "el-icon-user"
    }
  ]
}
```

---

## 数据模型

### 用户实体 (User)
```json
{
  "id": 1,              // 用户ID
  "no": "admin",        // 用户账号
  "name": "管理员",      // 用户姓名
  "password": "123456", // 密码
  "age": 25,            // 年龄
  "sex": 1,             // 性别：1-男，0-女
  "roleId": 1,          // 角色ID
  "phone": "13800138000", // 手机号
  "isValid": "1"        // 是否有效：1-有效，0-无效
}
```

### 商品实体 (Goods)
```json
{
  "id": 1,              // 商品ID
  "name": "商品A",       // 商品名称
  "storage": 1,         // 仓库ID
  "goodstype": 1,       // 商品类型ID
  "count": 50,          // 库存数量
  "remark": "备注"      // 备注
}
```

### 商品类型实体 (Goodstype)
```json
{
  "id": 1,              // 类型ID
  "name": "电子产品",    // 类型名称
  "remark": "备注"      // 备注
}
```

### 仓库实体 (Storage)
```json
{
  "id": 1,              // 仓库ID
  "name": "主仓库",      // 仓库名称
  "remark": "备注"      // 备注
}
```

### 操作记录实体 (Operation)
```json
{
  "id": 1,              // 操作ID
  "no": "OP001",        // 订单号
  "good": "商品A",       // 商品名称
  "goodstype": 1,       // 商品类型ID
  "count": 10,          // 操作数量
  "storage": 1,         // 仓库ID
  "type": "0"           // 操作类型：0-入库，1-出库
}
```

### 菜单实体 (Menu)
```json
{
  "id": 1,              // 菜单ID
  "menucode": "001",    // 菜单编码
  "menuname": "用户管理", // 菜单名称
  "menulevel": "1",     // 菜单级别
  "menuparentcode": "0", // 父菜单编码
  "menuclick": "/user", // 点击路径
  "menuright": "1",     // 权限标识
  "menucomponent": "UserManage", // 组件名称
  "menuicon": "el-icon-user" // 图标
}
```

---

## 错误码说明

| 错误码 | 说明 |
|--------|------|
| 200 | 成功 |
| 400 | 失败 |
