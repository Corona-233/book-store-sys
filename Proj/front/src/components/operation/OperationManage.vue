<script>
import { operationApi } from '@/api/operation'
import { goodsApi } from '@/api/goods'

export default {
  name: "OperationManage",
  data() {
    return {
      tableData: [],
      storageData: [],
      goodstypeData: [],
      pageNum: 1,
      pageSize: 10,
      total: 0,
      currentStock: 0, // 当前库存数量
      checkingStock: false, // 检查库存状态
      // 商品名自动补全相关
      goodsNameSuggestions: [], // 商品名建议列表
      showSuggestions: false, // 是否显示建议
      suggestionLoading: false, // 建议加载状态
      // 商品类型智能提示相关
      filteredGoodstypeData: [], // 过滤后的商品类型数据
      goodsTypeMapping: {}, // 商品名称与类型的映射关系
      // 查询条件
      no: '',
      storage: '',
      good: '',
      goodstype: '',
      type: '',
      // 操作类型选项
      typeOptions: [
        { value: '0', label: '入库操作' },
        { value: '1', label: '出库操作' }
      ],
      centerDialogVisible: false,
      form: {
        id: '',
        no: '',
        storage: '',
        good: '',
        goodstype: '',
        type: '',
        count: ''
      },
      rules: {
        no: [
          { required: true, message: '请输入订单号', trigger: 'blur' }
        ],
        storage: [
          { required: true, message: '请选择仓库', trigger: 'change' }
        ],
        good: [
          { required: true, message: '请输入商品名', trigger: 'blur' }
        ],
        goodstype: [
          { required: true, message: '请选择商品类型', trigger: 'change' }
        ],
        type: [
          { required: true, message: '请选择操作类型', trigger: 'change' }
        ],
        count: [
          { required: true, message: '请输入操作数量', trigger: 'blur' },
          { pattern: /^([1-9][0-9]*){1,4}$/, message: '数量必须为正整数', trigger: 'blur' }
        ]
      }
    }
  },
  methods: {
    handleSizeChange(val) {
      console.log(`每页 ${val} 条`);
      this.pageNum = 1
      this.pageSize = val
      this.loadPost()
    },
    handleCurrentChange(val) {
      console.log(`当前页: ${val}`);
      this.pageNum = val
      this.loadPost()
    },
    // 查询操作记录
    loadPost() {
      operationApi.listPage({
        pageSize: this.pageSize,
        pageNum: this.pageNum,
        param: {
          no: this.no,
          storage: this.storage + '',
          good: this.good,
          goodstype: this.goodstype + '',
          type: this.type
        }
      }).then(res => {
        console.log(res)
        if (res.code == 200) {
          this.tableData = res.data
          this.total = res.total
        } else {
          alert('获取数据失败')
        }
      })
    },
    resetParam() {
      this.no = ''
      this.storage = ''
      this.good = ''
      this.goodstype = ''
      this.type = ''
    },
    addData() {
      this.centerDialogVisible = true
      this.$nextTick(() => {
        this.resetForm()
      })
      this.form.id = ''
      // 自动生成订单号
      this.generateOrderNo()
    },
    saveData() {
      this.$refs.form.validate((valid) => {
        if (valid) {
          // 如果是出库操作，检查库存是否足够
          if (this.form.type === '1') {
            const requestCount = parseInt(this.form.count);
            if (requestCount > this.currentStock) {
              this.$message({
                message: `库存不足！当前库存：${this.currentStock}，请求出库：${requestCount}`,
                type: 'error'
              });
              return false;
            }
          }
          
          if (this.form.id) {
            this.doMod();
          } else {
            this.doSave();
          }
        } else {
          console.log('error submit!!');
          return false;
        }
      });
    },
    mod(row) {
      this.centerDialogVisible = true
      this.$nextTick(() => {
        this.form.id = row.id
        this.form.no = row.no
        this.form.storage = row.storage
        this.form.good = row.good
        this.form.goodstype = row.goodstype
        this.form.type = row.type + ''
        this.form.count = row.count
        // 编辑时也检查库存
        this.onGoodOrStorageChange();
      })
    },
    doMod() {
      operationApi.update(this.form).then(res => {
        if (res.code == 200) {
          this.$message({
            message: '修改成功！',
            type: 'success'
          });
          this.centerDialogVisible = false
          this.loadPost()
          this.resetForm()
        } else {
          this.$message({
            message: '修改失败！',
            type: 'error'
          });
        }
      })
    },
    doSave() {
      operationApi.save(this.form).then(res => {
        if (res.code == 200) {
          this.$message({
            message: '添加成功！',
            type: 'success'
          });
          this.centerDialogVisible = false
          this.loadPost()
          this.resetForm()
        } else {
          this.$message({
            message: '添加失败！',
            type: 'error'
          });
        }
      })
    },
    del(id) {
      operationApi.delete(id).then(res => {
        if (res.code == 200) {
          this.$message({
            message: '删除成功！',
            type: 'success'
          });
          this.loadPost()
        } else {
          this.$message({
            message: '删除失败！',
            type: 'error'
          });
        }
      })
    },
    resetForm() {
      this.$refs.form.resetFields();
    },
    // 加载仓库列表
    loadStorage() {
      operationApi.getStorageList().then(res => {
        console.log(res)
        if (res.code == 200) {
          this.storageData = res.data
        } else {
          alert('获取仓库数据失败')
        }
      })
    },
    // 加载商品类型列表
    loadGoodstype() {
      operationApi.getGoodsTypeList().then(res => {
        console.log(res)
        if (res.code == 200) {
          this.goodstypeData = res.data
          // 初始化过滤数据
          this.filteredGoodstypeData = [...this.goodstypeData]
        } else {
          alert('获取商品类型数据失败')
        }
      })
    },
    // 格式化仓库名称
    formatStorage(row) {
      let t = this.storageData.find(item => {
        return item.id == row.storage
      })
      return t && t.name
    },
    // 格式化商品类型名称
    formatGoodsType(row) {
      let t = this.goodstypeData.find(item => {
        return item.id == row.goodstype
      })
      return t && t.name
    },
    // 格式化操作类型
    formatType(row) {
      return row.type == '0' ? '入库操作' : '出库操作'
    },
    // 检查当前库存
    checkCurrentStock() {
      if (!this.form.good || !this.form.storage) {
        this.currentStock = 0;
        return;
      }
      
      this.checkingStock = true;
      
      // 获取该商品在该仓库的所有操作记录
      operationApi.listPage({
        pageSize: 1000,
        pageNum: 1,
        param: {
          good: this.form.good,
          storage: this.form.storage + ''
        }
      }).then(res => {
        if (res.code == 200) {
          const operations = res.data || [];
          let stock = 0;
          
          // 计算当前库存：入库 - 出库
          operations.forEach(operation => {
            if (operation.type === '0') {
              // 入库操作
              stock += operation.count;
            } else if (operation.type === '1') {
              // 出库操作
              stock -= operation.count;
            }
          });
          
          this.currentStock = stock;
          console.log(`商品 ${this.form.good} 在仓库 ${this.form.storage} 的当前库存: ${stock}`);
        } else {
          this.currentStock = 0;
        }
        this.checkingStock = false;
      }).catch(error => {
        console.error('检查库存失败:', error);
        this.currentStock = 0;
        this.checkingStock = false;
      });
    },
    // 监听商品和仓库变化
    onGoodOrStorageChange() {
      this.currentStock = 0;
      if (this.form.good && this.form.storage) {
        this.checkCurrentStock();
      }
    },
    // 获取仓库名称
    getStorageName(storageId) {
      const storage = this.storageData.find(item => item.id == storageId);
      return storage ? storage.name : '未知仓库';
    },
    // 获取商品名称建议
    getGoodsNameSuggestions(keyword) {
      if (!keyword || keyword.length < 1) {
        this.goodsNameSuggestions = [];
        this.showSuggestions = false;
        return;
      }
      
      this.suggestionLoading = true;
      
      // 调用后端API获取商品名称建议
      goodsApi.getGoodsNameSuggestions(keyword).then(res => {
        if (res.code == 200) {
          this.goodsNameSuggestions = res.data || [];
          this.showSuggestions = this.goodsNameSuggestions.length > 0;
        } else {
          this.goodsNameSuggestions = [];
          this.showSuggestions = false;
        }
        this.suggestionLoading = false;
      }).catch(error => {
        console.error('获取商品名称建议失败:', error);
        this.goodsNameSuggestions = [];
        this.showSuggestions = false;
        this.suggestionLoading = false;
      });
    },
    // 选择建议的商品名
    selectGoodsName(name) {
      this.form.good = name;
      this.showSuggestions = false;
      this.goodsNameSuggestions = [];
      // 选择商品后检查库存和过滤类型
      this.onGoodOrStorageChange();
      this.onGoodsNameChange();
    },
    // 隐藏建议列表
    hideSuggestions() {
      setTimeout(() => {
        this.showSuggestions = false;
      }, 200);
    },
    // 商品名输入事件
    onGoodInput(value) {
      this.onGoodOrStorageChange();
      this.getGoodsNameSuggestions(value);
      this.onGoodsNameChange();
    },
    // 商品名获得焦点事件
    onGoodFocus() {
      if (this.form.good) {
        this.getGoodsNameSuggestions(this.form.good);
      }
    },
    // 初始化商品类型映射关系
    initGoodsTypeMapping() {
      // 从后端获取商品类型映射关系
      goodsApi.getGoodsTypeMapping().then(res => {
        if (res.code == 200) {
          this.goodsTypeMapping = res.data || {};
        }
      }).catch(error => {
        console.error('获取商品类型映射失败:', error);
        // 保持空映射，不提供默认数据
        this.goodsTypeMapping = {};
      });
    },
    // 根据商品名称过滤商品类型
    filterGoodsTypeByGoodsName() {
      if (!this.form.good) {
        this.filteredGoodstypeData = [...this.goodstypeData];
        return;
      }
      
      const suggestedType = this.goodsTypeMapping[this.form.good];
      if (suggestedType) {
        // 将建议的类型放在第一位
        this.filteredGoodstypeData = this.goodstypeData.sort((a, b) => {
          if (a.name === suggestedType) return -1;
          if (b.name === suggestedType) return 1;
          return 0;
        });
      } else {
        this.filteredGoodstypeData = [...this.goodstypeData];
      }
    },
    // 商品名称变化时重新过滤类型
    onGoodsNameChange() {
      this.filterGoodsTypeByGoodsName();
    },
    // 判断是否为推荐类型
    isSuggestedType(typeName) {
      if (!this.form.good) return false;
      const suggestedType = this.goodsTypeMapping[this.form.good];
      return suggestedType === typeName;
    },
    // 生成订单号
    generateOrderNo() {
      const now = new Date();
      const year = now.getFullYear();
      const month = String(now.getMonth() + 1).padStart(2, '0');
      const day = String(now.getDate()).padStart(2, '0');
      const hours = String(now.getHours()).padStart(2, '0');
      const minutes = String(now.getMinutes()).padStart(2, '0');
      const seconds = String(now.getSeconds()).padStart(2, '0');
      const milliseconds = String(now.getMilliseconds()).padStart(3, '0');
      
      // 格式：YYYYMMDDHHMMSS + 3位毫秒数
      const orderNo = `${year}${month}${day}${hours}${minutes}${seconds}${milliseconds}`;
      this.form.no = orderNo;
    }
  },
  beforeMount() {
    this.loadStorage()
    this.loadGoodstype()
    this.loadPost()
    this.initGoodsTypeMapping()
  }
}
</script>

<template>
  <div>
    <div style="text-align: center; margin-bottom: 5px">
      <el-input v-model="no"
                placeholder="请输入订单号"
                suffix-icon="el-icon-search"
                style="width: 150px"
                @keyup.enter.native="loadPost"
                ></el-input>
      <el-select v-model="storage" placeholder="请选择仓库" style="margin-left: 10px; width: 120px">
        <el-option
            v-for="item in storageData"
            :key="item.id"
            :label="item.name"
            :value="item.id">
        </el-option>
      </el-select>
      <el-input v-model="good"
                placeholder="请输入商品名"
                style="margin-left: 10px; width: 150px"
                @keyup.enter.native="loadPost"></el-input>
      <el-select v-model="goodstype" placeholder="请选择类型" style="margin-left: 10px; width: 120px">
        <el-option
            v-for="item in goodstypeData"
            :key="item.id"
            :label="item.name"
            :value="item.id">
        </el-option>
      </el-select>
      <el-select v-model="type" placeholder="请选择操作类型" style="margin-left: 10px; width: 120px">
        <el-option
            v-for="item in typeOptions"
            :key="item.value"
            :label="item.label"
            :value="item.value">
        </el-option>
      </el-select>
      <el-button style="margin-left: 10px" @click="loadPost">查询</el-button>
      <el-button @click="resetParam">重置</el-button>
      <el-button style="margin-left: 10px" @click="addData">新增</el-button>
    </div>
    <el-table :data="tableData"
              :header-cell-style="{background:'rgb(186,204,238)',color:'rgba(0,0,0,0.6)'}"
              border
              style="width: 100%"
    >
      <el-table-column prop="no" label="订单号" min-width="150">
      </el-table-column>
      <el-table-column prop="storage" label="仓库" min-width="120" :formatter="formatStorage">
      </el-table-column>
      <el-table-column prop="good" label="商品" min-width="150">
      </el-table-column>
      <el-table-column prop="goodstype" label="商品类型" min-width="120" :formatter="formatGoodsType">
      </el-table-column>
      <el-table-column prop="type" label="操作类型" min-width="120" :formatter="formatType">
        <template slot-scope="scope">
          <el-tag
              :type="scope.row.type === '0' ? 'success' : 'warning'"
              disable-transitions>{{formatType(scope.row)}}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="count" label="操作数量" min-width="120">
      </el-table-column>
      <el-table-column prop="operate" label="操作" width="200" fixed="right">
        <template slot-scope="scope">
          <el-button size="small" type="primary" @click="mod(scope.row)" style="margin-left: 25px">编辑</el-button>
          <el-popconfirm
              title="您确定删除该条数据吗？"
              @confirm="del(scope.row.id)"
              style="margin-left: 10px"
          >
            <el-button slot="reference" size="small" type="danger" style="margin-left: 10px">删除</el-button>
          </el-popconfirm>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination style="text-align:center; margin-top: 10px"
                   @size-change="handleSizeChange"
                   @current-change="handleCurrentChange"
                   :current-page="pageNum"
                   :page-sizes="[10, 20, 50, 100]"
                   :page-size="pageSize"
                   layout="total, sizes, prev, pager, next, jumper"
                   :total="total">
    </el-pagination>
    <el-dialog
        title="提示"
        :visible.sync="centerDialogVisible"
        width="30%"
        center>
      <el-form ref="form" :rules="rules" :model="form" label-width="80px">
        <el-form-item label="订单号" prop="no">
          <el-col :span="18">
            <el-input 
              v-model="form.no" 
              readonly 
              disabled
              style="background-color: #f5f7fa; color: #606266; cursor: not-allowed;">
            </el-input>
          </el-col>
        </el-form-item>
        <el-form-item label="仓库" prop="storage">
          <el-col :span="18">
            <el-select v-model="form.storage" placeholder="请选择仓库" style="width: 100%" @change="onGoodOrStorageChange">
              <el-option
                  v-for="item in storageData"
                  :key="item.id"
                  :label="item.name"
                  :value="item.id">
              </el-option>
            </el-select>
          </el-col>
        </el-form-item>
        <el-form-item label="商品" prop="good">
          <el-col :span="18">
            <div style="position: relative;">
              <el-input 
                v-model="form.good" 
                placeholder="请输入商品名" 
                @input="onGoodInput"
                @focus="onGoodFocus"
                @blur="hideSuggestions"
                ref="goodsInput">
              </el-input>
              
              <!-- 商品名建议列表 -->
              <div 
                v-if="showSuggestions && goodsNameSuggestions.length > 0" 
                class="goods-suggestions"
                style="position: absolute; top: 100%; left: 0; right: 0; z-index: 1000; background: white; border: 1px solid #dcdfe6; border-radius: 4px; box-shadow: 0 2px 12px 0 rgba(0,0,0,0.1); max-height: 200px; overflow-y: auto;">
                
                <div v-if="suggestionLoading" style="padding: 10px; text-align: center; color: #999;">
                  <i class="el-icon-loading"></i> 搜索中...
                </div>
                
                <div 
                  v-for="(suggestion, index) in goodsNameSuggestions" 
                  :key="index"
                  @click="selectGoodsName(suggestion)"
                  style="padding: 8px 12px; cursor: pointer; border-bottom: 1px solid #f5f5f5;"
                  :style="{ backgroundColor: index % 2 === 0 ? '#fafafa' : 'white' }"
                  @mouseenter="$event.target.style.backgroundColor = '#e6f7ff'"
                  @mouseleave="$event.target.style.backgroundColor = index % 2 === 0 ? '#fafafa' : 'white'">
                  <i class="el-icon-goods" style="margin-right: 8px; color: #409eff;"></i>
                  {{ suggestion }}
                </div>
                
                <div v-if="!suggestionLoading && goodsNameSuggestions.length === 0" style="padding: 10px; text-align: center; color: #999;">
                  没有找到相关商品
                </div>
              </div>
            </div>
          </el-col>
        </el-form-item>
        <el-form-item label="商品类型" prop="goodstype">
          <el-col :span="18">
            <el-select 
              v-model="form.goodstype" 
              placeholder="请选择商品类型" 
              style="width: 100%"
              @focus="onGoodsNameChange"
              @change="onGoodOrStorageChange">
              <el-option
                  v-for="(item, index) in filteredGoodstypeData"
                  :key="item.id"
                  :label="item.name"
                  :value="item.id"
                  :class="{ 'suggested-type': isSuggestedType(item.name) }"
                  :style="{ 
                    backgroundColor: isSuggestedType(item.name) ? '#e6f7ff' : 'white',
                    color: isSuggestedType(item.name) ? '#409eff' : 'inherit',
                    fontWeight: isSuggestedType(item.name) ? 'bold' : 'normal'
                  }">
                <span v-if="isSuggestedType(item.name)" style="color: #409eff;">
                  <i class="el-icon-star-on" style="margin-right: 5px;"></i>
                  {{ item.name }}
                  <el-tag size="mini" type="success" style="margin-left: 8px;">推荐</el-tag>
                </span>
                <span v-else>{{ item.name }}</span>
              </el-option>
            </el-select>
          </el-col>
        </el-form-item>
        <el-form-item label="操作类型" prop="type">
          <el-col :span="18">
            <el-radio-group v-model="form.type">
              <el-radio label="0">入库操作</el-radio>
              <el-radio label="1">出库操作</el-radio>
            </el-radio-group>
          </el-col>
        </el-form-item>
        <el-form-item label="操作数量" prop="count">
          <el-col :span="18">
            <el-input v-model="form.count"></el-input>
          </el-col>
        </el-form-item>
        <!-- 当前库存显示 -->
        <el-form-item label="当前库存" v-if="form.good && form.storage">
          <el-col :span="18">
            <div style="display: flex; align-items: center;">
              <el-tag 
                :type="currentStock > 0 ? 'success' : (currentStock === 0 ? 'info' : 'danger')"
                v-if="!checkingStock">
                {{ currentStock }}
              </el-tag>
              <span v-else style="color: #999;">
                <i class="el-icon-loading"></i> 检查中...
              </span>
              <span style="margin-left: 10px; color: #666; font-size: 12px;">
                ({{ form.good }} 在 {{ getStorageName(form.storage) }} 的库存)
              </span>
            </div>
          </el-col>
        </el-form-item>
        <!-- 出库警告 -->
        <el-form-item v-if="form.type === '1' && form.count && currentStock > 0">
          <el-col :span="18">
            <el-alert
              :title="parseInt(form.count) > currentStock ? '库存不足警告' : '出库确认'"
              :type="parseInt(form.count) > currentStock ? 'error' : 'warning'"
              :description="parseInt(form.count) > currentStock ? 
                `当前库存：${currentStock}，请求出库：${form.count}，超出：${parseInt(form.count) - currentStock}` :
                `当前库存：${currentStock}，出库后剩余：${currentStock - parseInt(form.count)}`"
              show-icon
              :closable="false">
            </el-alert>
          </el-col>
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="centerDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="saveData">确 定</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<style scoped>
.goods-suggestions {
  animation: fadeIn 0.2s ease-in-out;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(-5px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.goods-suggestions div:hover {
  background-color: #e6f7ff !important;
  color: #409eff;
}

.goods-suggestions div:last-child {
  border-bottom: none;
}

/* 推荐类型样式 */
.suggested-type {
  background-color: #e6f7ff !important;
  color: #409eff !important;
  font-weight: bold !important;
}

.suggested-type:hover {
  background-color: #bae7ff !important;
}

/* 商品类型选择框优化 */
.el-select-dropdown__item.suggested-type {
  border-left: 3px solid #409eff;
  padding-left: 8px;
}
</style>
