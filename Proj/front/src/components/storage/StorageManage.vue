<script>
import { storageApi } from '@/api/storage'
import { goodsApi } from '@/api/goods'
import { operationApi } from '@/api/operation'

export default {
  name: "StorageManage",
  data() {
    return {
      tableData: [],
      pageNum: 1,
      pageSize: 10,
      total: 0,
      name: '',
      centerDialogVisible: false,
      form: {
        id: '',
        name: '',
        remark: ''
      },
      rules: {
        name: [
          {required: true, message: '请输入仓库名', trigger: 'blur'}
        ],
      },
      // 查看仓库物品相关数据
      viewDialogVisible: false,
      currentStorage: null,
      goodsInStorage: [],
      goodsPageNum: 1,
      goodsPageSize: 10,
      goodsTotal: 0,
      goodsSearchName: '',
      goodstypeData: [],
      loadingGoods: false
    }
  },
  methods:{
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
    loadPost(){
      storageApi.listPage({
        pageSize: this.pageSize,
        pageNum: this.pageNum,
        param: {
          name: this.name,
        }
      }).then(res=>{
        console.log(res)
        if(res.code==200){
          this.tableData=res.data
          this.total=res.total
        }else{
          alert('获取数据失败')
        }
      })
    },
    resetParam(){
      this.name = ''

    },
    addData(){
      this.centerDialogVisible = true
      this.$nextTick(()=>{this.resetForm()})
      this.form.id = ''
    },
    saveData(){
      this.$refs.form.validate((valid) => {
        if (valid) {
          if(this.form.id){
            this.doMod();
          }else{
            this.doSave();
          }
        } else {
          console.log('error submit!!');
          return false;
        }
      });
    },
    mod(row){
      this.centerDialogVisible = true
      this.$nextTick(()=>{
        this.form.id = row.id
        this.form.name = row.name
        this.form.remark = row.remark
      })

    },
    doMod(){
      storageApi.update(this.form).then(res=>{
        if(res.code==200){
          this.$message({
            message: '修改成功！',
            type: 'success'
          });
          this.centerDialogVisible = false
          this.loadPost()
          this.resetForm()
        }else{
          this.$message({
            message: '修改失败！',
            type: 'error'
          });
        }
      })
    },
    doSave(){
      storageApi.save(this.form).then(res=>{
        if(res.code==200){
          this.$message({
            message: '添加成功！',
            type: 'success'
          });
          this.centerDialogVisible = false
          this.loadPost()
          this.resetForm()
        }else{
          this.$message({
            message: '添加失败！',
            type: 'error'
          });
        }
      })
    },
    del(id){
      storageApi.delete(id).then(res=>{
        if(res.code==200){
          this.$message({
            message: '删除成功！',
            type: 'success'
          });
          this.loadPost()
        }else{
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
    // 查看仓库物品
    viewStorage(row) {
      console.log('查看仓库:', row);
      this.currentStorage = row;
      this.viewDialogVisible = true;
      this.goodsSearchName = '';
      this.goodsPageNum = 1;
      this.goodsPageSize = 10;
      this.goodsTotal = 0;
      this.goodsInStorage = [];
      this.loadGoodsInStorage();
    },
    // 加载仓库中的物品
    loadGoodsInStorage() {
      if (!this.currentStorage || !this.currentStorage.id) {
        this.$message({
          message: '仓库信息错误',
          type: 'error'
        });
        return;
      }
      
      this.loadingGoods = true;
      
      goodsApi.listPage({
        pageSize: this.goodsPageSize,
        pageNum: this.goodsPageNum,
        param: {
          name: this.goodsSearchName || '',
          storage: this.currentStorage.id + ''
        }
      }).then(res => {
        console.log('仓库物品查询结果:', res);
        if (res.code == 200) {
          this.goodsInStorage = res.data;
          this.goodsTotal = res.total;
          // 为每个商品计算实际库存
          this.calculateStockForGoods();
        } else {
          this.$message({
            message: '获取仓库物品失败: ' + (res.msg || '未知错误'),
            type: 'error'
          });
          this.loadingGoods = false;
        }
      }).catch(error => {
        console.error('API调用错误:', error);
        this.$message({
          message: '网络请求失败: ' + error.message,
          type: 'error'
        });
        this.loadingGoods = false;
      });
    },
    // 物品分页处理
    handleGoodsSizeChange(val) {
      this.goodsPageNum = 1;
      this.goodsPageSize = val;
      this.loadGoodsInStorage();
    },
    handleGoodsCurrentChange(val) {
      this.goodsPageNum = val;
      this.loadGoodsInStorage();
    },
    // 搜索仓库物品
    searchGoods() {
      this.goodsPageNum = 1;
      this.loadGoodsInStorage();
    },
    // 重置物品搜索
    resetGoodsSearch() {
      this.goodsSearchName = '';
      this.goodsPageNum = 1;
      this.loadGoodsInStorage();
    },
    // 格式化商品类型
    formatGoodsType(row) {
      let t = this.goodstypeData.find(item => {
        return item.id == row.goodstype;
      });
      return t && t.name;
    },
    // 加载商品类型列表
    loadGoodstype() {
      goodsApi.getGoodsTypeList().then(res => {
        console.log(res);
        if (res.code == 200) {
          this.goodstypeData = res.data;
        } else {
          console.log('获取商品类型数据失败');
        }
      });
    },
    // 为商品计算实际库存
    calculateStockForGoods() {
      if (!this.goodsInStorage || this.goodsInStorage.length === 0) {
        this.loadingGoods = false;
        return;
      }
      
      // 为每个商品计算库存
      const promises = this.goodsInStorage.map(goods => {
        return this.calculateActualStock(goods.id, goods.name).then(stockResult => {
          goods.actualStock = stockResult.actualStock;
          goods.hasNegativeStock = stockResult.hasNegativeStock;
          goods.negativeStockOperations = stockResult.negativeStockOperations;
          return goods;
        });
      });
      
      Promise.all(promises).then(() => {
        this.loadingGoods = false;
        console.log('库存计算完成:', this.goodsInStorage);
      }).catch(error => {
        console.error('计算库存失败:', error);
        this.loadingGoods = false;
        this.$message({
          message: '计算库存失败',
          type: 'warning'
        });
      });
    },
    // 计算单个商品的实际库存
    calculateActualStock(goodsId, goodsName) {
      return new Promise((resolve, reject) => {
        // 获取该商品的所有操作记录
        operationApi.listPage({
          pageSize: 1000, // 获取所有记录
          pageNum: 1,
          param: {
            good: goodsName, // 根据商品名称查询
            storage: this.currentStorage.id + ''
          }
        }).then(res => {
          if (res.code == 200) {
            const operations = res.data || [];
            
            // 找到当前商品，获取其初始数量
            const currentGoods = this.goodsInStorage.find(g => g.id === goodsId);
            const initialStock = currentGoods ? (currentGoods.count || 0) : 0;
            
            let actualStock = initialStock; // 从初始库存开始计算
            let hasNegativeStock = false;
            let negativeStockOperations = [];
            
            // 按时间顺序计算库存，检测负库存操作
            operations.sort((a, b) => new Date(a.createTime || 0) - new Date(b.createTime || 0));
            
            operations.forEach((operation, index) => {
              const beforeStock = actualStock;
              
              if (operation.type === '0') {
                // 入库操作
                actualStock += operation.count;
              } else if (operation.type === '1') {
                // 出库操作 - 检查库存是否足够
                if (actualStock < operation.count) {
                  hasNegativeStock = true;
                  negativeStockOperations.push({
                    operation: operation,
                    beforeStock: beforeStock,
                    requestedCount: operation.count,
                    shortage: operation.count - beforeStock
                  });
                }
                actualStock -= operation.count;
              }
            });
            
            const result = {
              actualStock: actualStock,
              hasNegativeStock: hasNegativeStock,
              negativeStockOperations: negativeStockOperations
            };
            
            console.log(`商品 ${goodsName} 的初始库存: ${initialStock}, 操作后库存: ${actualStock}`, result);
            resolve(result);
          } else {
            console.log(`获取商品 ${goodsName} 操作记录失败`);
            // 如果无法获取操作记录，至少显示初始库存
            const currentGoods = this.goodsInStorage.find(g => g.id === goodsId);
            const initialStock = currentGoods ? (currentGoods.count || 0) : 0;
            resolve({
              actualStock: initialStock,
              hasNegativeStock: false,
              negativeStockOperations: []
            });
          }
        }).catch(error => {
          console.error(`计算商品 ${goodsName} 库存失败:`, error);
          // 出错时至少显示初始库存
          const currentGoods = this.goodsInStorage.find(g => g.id === goodsId);
          const initialStock = currentGoods ? (currentGoods.count || 0) : 0;
          resolve({
            actualStock: initialStock,
            hasNegativeStock: false,
            negativeStockOperations: []
          });
        });
      });
    }
  },
  computed: {
    // 检查是否有任何商品存在负库存异常
    hasAnyNegativeStock() {
      return this.goodsInStorage.some(goods => goods.hasNegativeStock);
    }
  },
  beforeMount() {
    this.loadPost();
    this.loadGoodstype();
  }
}
</script>

<template>
  <div>
    <div style="text-align: center; margin-bottom: 5px">
      <el-input v-model="name"
                placeholder="请输入仓库名"
                suffix-icon="el-icon-search"
                style="width: 200px"
                @keyup.enter.native="loadPost"></el-input>
      <el-button style="margin-left: 10px" @click="loadPost">查询</el-button>
      <el-button @click="resetParam">重置</el-button>
      <el-button style="margin-left: 10px" @click="addData">新增</el-button>
    </div>
    <el-table :data="tableData"
              :header-cell-style="{background:'rgb(186,204,238)',color:'rgba(0,0,0,0.6)'}"
              border
    >
      <el-table-column prop="name" label="仓库名" width="300">
      </el-table-column>
      <el-table-column prop="remark" label="备注">
      </el-table-column>

      <el-table-column prop="operate" label="操作" width="280">
        <template slot-scope="scope">
          <el-button size="small" type="info" @click="viewStorage(scope.row)">查看</el-button>
          <el-button size="small" type="primary" @click="mod(scope.row)" style="margin-left: 10px">编辑</el-button>
          <el-popconfirm
              title="您确定删除该条数据吗？"
              @confirm="del(scope.row.id)"
              style="margin-left: 10px"
          >
            <el-button slot="reference" size="small" type="danger">删除</el-button>
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
        <el-form-item label="仓库名" prop="name">
          <el-col :span="18">
            <el-input v-model="form.name"></el-input>
          </el-col>
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-col :span="18">
            <el-input v-model="form.remark" type="textarea"></el-input>
          </el-col>
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="centerDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="saveData">确 定</el-button>
      </span>
    </el-dialog>

    <!-- 查看仓库物品浮窗 -->
    <el-dialog
        :title="'仓库物品 - ' + (currentStorage ? currentStorage.name : '')"
        :visible.sync="viewDialogVisible"
        width="80%"
        center>
      <div style="margin-bottom: 15px;">
        <el-input v-model="goodsSearchName"
                  placeholder="请输入物品名称"
                  suffix-icon="el-icon-search"
                  style="width: 200px; margin-right: 10px;"
                  @keyup.enter.native="searchGoods"></el-input>
        <el-button @click="searchGoods" type="primary">查询</el-button>
        <el-button @click="resetGoodsSearch">重置</el-button>
      </div>
      
      <el-table :data="goodsInStorage"
                :header-cell-style="{background:'rgb(186,204,238)',color:'rgba(0,0,0,0.6)'}"
                border
                style="width: 100%"
                v-loading="loadingGoods"
                element-loading-text="正在计算库存...">
        <el-table-column prop="name" label="物品名称" min-width="150">
        </el-table-column>
        <el-table-column prop="goodstype" label="物品类型" min-width="120" :formatter="formatGoodsType">
        </el-table-column>
        <el-table-column prop="count" label="库存数量" min-width="150">
          <template slot-scope="scope">
            <el-tag 
              :type="scope.row.count > 0 ? 'success' : 'danger'"
              style="font-size: 14px; min-width: 40px; text-align: center; display: inline-block;">
              {{ scope.row.count }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="remark" label="备注" min-width="200">
        </el-table-column>
      </el-table>
      
      <!-- 异常操作详情 -->
      <div v-if="hasAnyNegativeStock" style="margin-top: 15px; padding: 10px; background-color: #fef0f0; border: 1px solid #fbc4c4; border-radius: 4px;">
        <h4 style="color: #f56c6c; margin: 0 0 10px 0;">
          <i class="el-icon-warning"></i> 库存异常警告
        </h4>
        <div v-for="goods in goodsInStorage" :key="goods.id" v-if="goods.hasNegativeStock">
          <div style="margin-bottom: 8px;">
            <strong style="color: #f56c6c;">{{ goods.name }}</strong> - 存在超量出库操作：
            <ul style="margin: 5px 0 0 20px; color: #666;">
              <li v-for="(negOp, index) in goods.negativeStockOperations" :key="index">
                订单号: {{ negOp.operation.no }} - 
                出库 {{ negOp.requestedCount }} 件，但当时库存只有 {{ negOp.beforeStock }} 件
                <span style="color: #f56c6c;">(超量 {{ negOp.shortage }} 件)</span>
              </li>
            </ul>
          </div>
        </div>
      </div>
      
      <el-pagination style="text-align:center; margin-top: 10px"
                     @size-change="handleGoodsSizeChange"
                     @current-change="handleGoodsCurrentChange"
                     :current-page="goodsPageNum"
                     :page-sizes="[10, 20, 50, 100]"
                     :page-size="goodsPageSize"
                     layout="total, sizes, prev, pager, next, jumper"
                     :total="goodsTotal">
      </el-pagination>
      
      <span slot="footer" class="dialog-footer">
        <el-button @click="viewDialogVisible = false">关 闭</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<style scoped>

</style>