<script>
import { goodstypeApi } from '@/api/goodstype'

export default {
  name: "GoodstypeManage",
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
          {required: true, message: '请输入类型名', trigger: 'blur'}
        ],
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
    loadPost(){
      goodstypeApi.listPage({
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
      goodstypeApi.update(this.form).then(res=>{
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
      goodstypeApi.save(this.form).then(res=>{
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
      goodstypeApi.delete(id).then(res=>{
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
    }
  },
  beforeMount() {
    this.loadPost()
  }
}
</script>

<template>
  <div>
    <div style="text-align: center; margin-bottom: 5px">
      <el-input v-model="name"
                placeholder="请输入类型名"
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
      <el-table-column prop="name" label="类型名" width="300">
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
        <el-form-item label="类型名" prop="name">
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
  </div>
</template>

<style scoped>

</style>