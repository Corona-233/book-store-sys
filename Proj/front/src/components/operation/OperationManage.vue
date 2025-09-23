<script>
import { operationApi } from '@/api/operation'

export default {
  name: "OperationManage",
  data() {
    return {
      tableData: [],
      storageData: [],
      goodstypeData: [],
      goodsData: [],
      pageNum: 1,
      pageSize: 10,
      total: 0,
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
          { required: true, message: '请选择商品', trigger: 'change' }
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
    },
    saveData() {
      this.$refs.form.validate((valid) => {
        if (valid) {
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
        } else {
          alert('获取商品类型数据失败')
        }
      })
    },
    // 加载商品列表
    loadGoods() {
      operationApi.getGoodsList().then(res => {
        console.log(res)
        if (res.code == 200) {
          this.goodsData = res.data
        } else {
          alert('获取商品数据失败')
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
    // 格式化商品名称
    formatGood(row) {
      let t = this.goodsData.find(item => {
        return item.id == row.good
      })
      return t && t.name
    },
    // 格式化操作类型
    formatType(row) {
      return row.type == '0' ? '入库操作' : '出库操作'
    }
  },
  beforeMount() {
    this.loadStorage()
    this.loadGoodstype()
    this.loadGoods()
    this.loadPost()
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
                @keyup.enter.native="loadPost"></el-input>
      <el-select v-model="storage" placeholder="请选择仓库" style="margin-left: 10px; width: 120px">
        <el-option
            v-for="item in storageData"
            :key="item.id"
            :label="item.name"
            :value="item.id">
        </el-option>
      </el-select>
      <el-select v-model="good" placeholder="请选择商品" style="margin-left: 10px; width: 120px">
        <el-option
            v-for="item in goodsData"
            :key="item.id"
            :label="item.name"
            :value="item.id">
        </el-option>
      </el-select>
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
    >
      <el-table-column prop="id" label="ID" width="60">
      </el-table-column>
      <el-table-column prop="no" label="订单号" width="150">
      </el-table-column>
      <el-table-column prop="storage" label="仓库" width="100" :formatter="formatStorage">
      </el-table-column>
      <el-table-column prop="good" label="商品" width="150" :formatter="formatGood">
      </el-table-column>
      <el-table-column prop="goodstype" label="商品类型" width="120" :formatter="formatGoodsType">
      </el-table-column>
      <el-table-column prop="type" label="操作类型" width="100" :formatter="formatType">
        <template slot-scope="scope">
          <el-tag
              :type="scope.row.type === '0' ? 'success' : 'warning'"
              disable-transitions>{{formatType(scope.row)}}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="count" label="操作数量" width="100">
      </el-table-column>
      <el-table-column prop="operate" label="操作" width="200">
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
        title="操作记录"
        :visible.sync="centerDialogVisible"
        width="40%"
        center>
      <el-form ref="form" :rules="rules" :model="form" label-width="100px">
        <el-form-item label="订单号" prop="no">
          <el-col :span="18">
            <el-input v-model="form.no"></el-input>
          </el-col>
        </el-form-item>
        <el-form-item label="仓库" prop="storage">
          <el-col :span="18">
            <el-select v-model="form.storage" placeholder="请选择仓库" style="width: 100%">
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
            <el-select v-model="form.good" placeholder="请选择商品" style="width: 100%">
              <el-option
                  v-for="item in goodsData"
                  :key="item.id"
                  :label="item.name"
                  :value="item.id">
              </el-option>
            </el-select>
          </el-col>
        </el-form-item>
        <el-form-item label="商品类型" prop="goodstype">
          <el-col :span="18">
            <el-select v-model="form.goodstype" placeholder="请选择商品类型" style="width: 100%">
              <el-option
                  v-for="item in goodstypeData"
                  :key="item.id"
                  :label="item.name"
                  :value="item.id">
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
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="centerDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="saveData">确 定</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<style scoped>

</style>
