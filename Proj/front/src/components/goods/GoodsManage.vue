<script>
import { goodsApi } from '@/api/goods'

export default {
  name: "GoodsManage",
  data() {
    return {
      tableData: [],
      storageData: [],
      goodstypeData: [],
      storage: '',
      goodstype: '',
      pageNum: 1,
      pageSize: 10,
      total: 0,
      name: '',
      centerDialogVisible: false,
      form: {
        id: '',
        name: '',
        storage: '',
        goodstype: '',
        count: 0,
        remark: ''
      },
      rules: {
        name: [
          {required: true, message: '请输入服装名', trigger: 'blur'}
        ],
        storage: [
          {required: true, message: '请输入仓库名', trigger: 'blur'}
        ],
        goodstype: [
          {required: true, message: '请输入类型名', trigger: 'blur'}
        ],
        count: [
          {required: true, message: '请输入数量', trigger: 'blur'},
          {pattern: /^([1-9][0-9]*){1,4}$/, message: '数量必须为正整数', trigger: 'blur'}
        ]
      }
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
    //查询
    loadPost(){
      goodsApi.listPage({
        pageSize: this.pageSize,
        pageNum: this.pageNum,
        param: {
          name: this.name,
          storage: this.storage+'',
          goodstype: this.goodstype+''
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
      this.storage = ''
      this.goodstype = ''

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
        this.form.storage = row.storage
        this.form.goodstype = row.goodstype
        this.form.count = row.count
        this.form.remark = row.remark
      })

    },
    doMod(){
      goodsApi.update(this.form).then(res=>{
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
      goodsApi.save(this.form).then(res=>{
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
      goodsApi.delete(id).then(res=>{
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
    loadStorage(){
      goodsApi.getStorageList().then(res=>{
        console.log(res)
        if(res.code==200){
          this.storageData=res.data
        }else{
          alert('获取数据失败')
        }
      })
    },
    loadGoodstype(){
      goodsApi.getGoodsTypeList().then(res=>{
        console.log(res)
        if(res.code==200){
          this.goodstypeData=res.data
        }else{
          alert('获取数据失败')
        }
      })
    },
    //对应仓库
    formatStorage(row){
      let t = this.storageData.find(item=>{
        return item.id == row.storage
      })
      return t && t.name
    },
    //对应类型
    formatGoodsType(row){
      let t = this.goodstypeData.find(item=>{
        return item.id == row.goodstype
      })
      return t && t.name
    }
  },
  beforeMount() {//加载上述方法
    this.loadStorage()
    this.loadGoodstype()
    this.loadPost()
  }
}
</script>

<template>
  <div>
    <div style="text-align: center; margin-bottom: 5px">
      <el-input v-model="name"
                placeholder="请输入服装名"
                suffix-icon="el-icon-search"
                style="width: 200px"
                @keyup.enter.native="loadPost"></el-input>
      <el-select v-model="storage" placeholder="请选择仓库">
        <el-option
            v-for="item in storageData"
            :key="item.id"
            :label="item.name"
            :value="item.id">
        </el-option>
      </el-select>
      <el-select v-model="goodstype" placeholder="请选择类型">
        <el-option
            v-for="item in goodstypeData"
            :key="item.id"
            :label="item.name"
            :value="item.id">
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
      <el-table-column prop="name" label="服装名" width="200">
      </el-table-column>
      <el-table-column prop="storage" label="仓库" width="100" :formatter="formatStorage">
      </el-table-column>
      <el-table-column prop="goodstype" label="类型" width="200" :formatter="formatGoodsType">
      </el-table-column>
      <el-table-column prop="count" label="数量" width="100">
      </el-table-column>
      <el-table-column prop="remark" label="备注">
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
        title="提示"
        :visible.sync="centerDialogVisible"
        width="30%"
        center>
      <el-form ref="form" :rules="rules" :model="form" label-width="80px">
        <el-form-item label="服装名" prop="name">
          <el-col :span="18">
            <el-input v-model="form.name"></el-input>
          </el-col>
        </el-form-item>
        <el-form-item label="仓库" prop="storage">
          <el-col :span="18">
            <el-select v-model="form.storage" placeholder="请选择仓库">
              <el-option
                  v-for="item in storageData"
                  :key="item.id"
                  :label="item.name"
                  :value="item.id">
              </el-option>
            </el-select>
          </el-col>
        </el-form-item>
        <el-form-item label="类型" prop="goodstype">
          <el-col :span="18">
            <el-select v-model="form.goodstype" placeholder="请选择类型">
              <el-option
                  v-for="item in goodstypeData"
                  :key="item.id"
                  :label="item.name"
                  :value="item.id">
              </el-option>
            </el-select>
          </el-col>
        </el-form-item>
        <el-form-item label="数量" prop="count">
          <el-col :span="18">
            <el-input v-model="form.count"></el-input>
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
  </div>
</template>

<style scoped>

</style>