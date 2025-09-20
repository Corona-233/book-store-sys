<script>
export default {
  name: "Login",
  data(){
    return{
      loginForm:{
        no: '',
        password: ''
      },
      rules:{
        no: [
          { required: true, message: '请输入帐号', trigger: 'blur' }
        ],
        password: [
          { required: true, message: '请输入密码', trigger: 'blur' }
        ]
      },
      // Mock用户数据
      mockUser: {
        id: 1,
        no: '100001',
        name: 'Corona',
        password: '123456',
        age: 18,
        sex: 1,
        phone: '12345678',
        role_id: 0,
        isValid: 'Y'
      },
      // Mock菜单数据
      mockMenu: [
        {
          menuname: '首页',
          menuclick: 'Home',
          menucomponent: 'Home'
        },
        {
          menuname: '用户管理',
          menuclick: 'user/UserManage',
          menucomponent: 'user/UserManage'
        },
        {
          menuname: '商品管理',
          menuclick: 'goods/GoodsManage',
          menucomponent: 'goods/GoodsManage'
        },
        {
          menuname: '商品分类管理',
          menuclick: 'goodstype/GoodstypeManage',
          menucomponent: 'goodstype/GoodstypeManage'
        },
        {
          menuname: '库存管理',
          menuclick: 'storage/StorageManage',
          menucomponent: 'storage/StorageManage'
        }
      ]
    }
  },
  methods: {
    confirm(){
      this.confirm_disabled = true;
      this.$refs.loginForm.validate((valid)=>{
        if (valid) {
          // 使用mock数据验证登录
          this.mockLogin();
        }else{
          this.confirm_disabled = false;
          return false;
        }
      });
    },
    
    // Mock登录方法
    mockLogin() {
      // 模拟网络延迟
        // 验证用户名和密码
      if (this.loginForm.no === this.mockUser.no && this.loginForm.password === this.mockUser.password) {
        // 登录成功
        const mockResponse = {
          code: 200,
          data: {
            user: this.mockUser,
            menu: this.mockMenu
          }
        };
          
        // 存储用户信息
        sessionStorage.setItem("CurUser", JSON.stringify(mockResponse.data.user));
        console.log('Mock登录成功，用户信息:', mockResponse.data.user);
        console.log('Mock菜单数据:', mockResponse.data.menu);
          
        // 存储菜单到store
        this.$store.commit("setMenu", mockResponse.data.menu);
          
        // 跳转到主页
        this.$router.replace('/Index');
      } else {
        // 登录失败
        this.confirm_disabled = false;
        alert('用户名或密码错误！');
      }
    }
  }
}
</script>

<template>
  <div class="loginBody">
    <img  class="img" src="./img/sandk.jpg"/>
    <div class="loginDiv">
      <div class="login-content">
        <h1 class="login-title" style="margin-bottom: 24px; color: rgba(255,255,255,0.6)">用户登录</h1>
        <el-form :model="loginForm" label-width="100px"
                 :rules="rules" ref="loginForm">
          <el-form-item label="帐号" prop="no">
            <el-input style="width: 220px" type="text" v-model="loginForm.no"
                      autocomplete="off" size="small"></el-input>
          </el-form-item>
          <el-form-item label="密码" style="margin-top: 30px" prop="password">
            <el-input style="width: 220px" type="password" v-model="loginForm.password"
                      show-password autocomplete="off" size="small" @keyup.enter.native="confirm"></el-input>
          </el-form-item>
          <el-form-item style="margin-left: 70px; margin-top: 30px">
            <el-button type="primary" @click="confirm" >确 定</el-button>
          </el-form-item>
        </el-form>
      </div>
    </div>
  </div>
</template>

<style scoped>
  .loginBody {
    position: absolute;
    width: 100%;
    height: 100%;
  }
  .img {
    height: 100%;
    width: 100%;
  }
  .loginDiv {
    position: absolute;
    top: 50%;
    left: 50%;
    margin-top: -200px;
    margin-left: -240px;
    width: 450px;
    height: 330px;
    border-radius: 5%;
    backdrop-filter: blur(50px);
    box-shadow: 0 0 6px 2px rgba(0, 0, 0, 0.2);
  }
  .login-title {
    margin: 20px 0;
    text-align: center;
  }
  .login-content {
    width: 400px;
    height: 250px;
    position: absolute;
    top: 25px;
    left: 25px;
  }
</style>