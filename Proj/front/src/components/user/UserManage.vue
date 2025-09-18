<script>
export default {
  name: "UserManage",
  data() {
    let checkDuplicate = (rule, value, callback) => {
      if (this.form.id) {
        return callback();
      }
      this.$axios.get("http://localhost:8090/user/findByNo?no=" + this.form.no).then(res => res.data).then(res => {
        if (res.code != 200) {
          callback()
        } else {
          callback(new Error('帐号已存在'))
        }
      })
    }
    return {
      tableData: [],
      pageNum: 1,
      pageSize: 10,
      total: 0,
      name: '',
      sex: '',
      sexs: [
        {
          value: '1',
          label: '男'
        },
        {
          value: '0',
          label: '女'
        }
      ],
      centerDialogVisible: false,
      form: {
        id: '',
        name: '',
        no: '',
        password: '',
        age: '',
        phone: '',
        sex: '1',
        roleId: '2'
      },
      rules: {
        name: [
          {required: true, message: '请输入姓名', trigger: 'blur'}
        ],
        no: [
          {required: true, message: '请输入帐号', trigger: 'blur'},
          {min: 5, max: 20, message: '长度在 5 到 20 个字符', trigger: 'blur'},
          {validator: checkDuplicate, trigger: 'blur'}
        ],
        password: [
          {required: true, message: '请输入密码', trigger: 'blur'},
          {min: 5, max: 20, message: '长度在 5 到 20 个字符', trigger: 'blur'}
        ],
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
    loadPost() {
      this.$axios.post('http://localhost:8090/user/listPage', {
        pageSize: this.pageSize,
        pageNum: this.pageNum,
        param: {
          name: this.name,
          sex: this.sex,
          roleId: '2'
        }
      }).then(res => res.data).then(res => {
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
      this.name = ''
      this.sex = ''
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
        this.form.name = row.name
        this.form.no = row.no
        this.form.password = ''
        this.form.age = row.age + ''
        this.form.sex = row.sex + ''
        this.form.phone = row.phone
        this.form.roleId = row.roleId
      })

    },
    doMod() {
      this.$axios.post('http://localhost:8090/user/update', this.form).then(res => res.data).then(res => {
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
      this.$axios.post('http://localhost:8090/user/save', this.form).then(res => res.data).then(res => {
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
      this.$axios.get('http://localhost:8090/user/del?id=' + id).then(res => res.data).then(res => {
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
                placeholder="请输入姓名"
                suffix-icon="el-icon-search"
                style="width: 200px"
                @keyup.enter.native="loadPost"></el-input>
      <el-select v-model="sex" filterable placeholder="请选择性别" style="margin-left: 10px">
        <el-option
            v-for="item in sexs"
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
      <el-table-column prop="id" label="ID" width="40">
      </el-table-column>
      <el-table-column prop="no" label="帐号" width="150">
      </el-table-column>
      <el-table-column prop="name" label="姓名" width="150">
      </el-table-column>
      <el-table-column prop="age" label="年龄" width="120">
      </el-table-column>
      <el-table-column prop="sex" label="性别" width="120">
        <template slot-scope="scope">
          <el-tag
              :type="scope.row.sex === 1 ? 'primary' : 'success'"
              disable-transitions>{{scope.row.sex === 1 ? '男' : '女'}}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="phone" label="手机号码">
      </el-table-column>
      <el-table-column prop="roleId" label="权限" width="120">
        <template slot-scope="scope">
          <el-tag
              :type="scope.row.roleId === 0 ? 'danger' : (scope.row.roleId === 1 ? 'primary' : 'success')"
              disable-transitions>{{scope.row.roleId === 0 ? '超级管理员' : (scope.row.roleId === 1 ? '管理员' : '普通用户')}}</el-tag>
        </template>
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
        <el-form-item label="姓名" prop="name">
          <el-col :span="18">
            <el-input v-model="form.name"></el-input>
          </el-col>
        </el-form-item>
        <el-form-item label="帐号" prop="no">
          <el-col :span="18">
            <el-input v-model="form.no"></el-input>
          </el-col>
        </el-form-item>
        <el-form-item label="密码" prop="password">
          <el-col :span="18">
            <el-input v-model="form.password"></el-input>
          </el-col>
        </el-form-item>
        <el-form-item label="年龄" prop="age">
          <el-col :span="18">
            <el-input v-model="form.age"></el-input>
          </el-col>
        </el-form-item>
        <el-form-item label="性别">
          <el-radio-group v-model="form.sex">
            <el-radio label="1">男</el-radio>
            <el-radio label="0">女</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="电话" prop="phone">
          <el-col :span="18">
            <el-input v-model="form.phone"></el-input>
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