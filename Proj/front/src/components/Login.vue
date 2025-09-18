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
      }
    }
  },
  methods: {
    confirm(){
      this.confirm_disabled = true;
      this.$refs.loginForm.validate((valid)=>{
        if (valid) {
          this.$axios.post("http://localhost:8090/user/login", this.loginForm).then(res=>res.data).then(res=>{
            if(res.code==200){
              //存储
              sessionStorage.setItem("CurUser",JSON.stringify(res.data.user))
              console.log(res.data.menu)
              this.$store.commit("setMenu",res.data.menu)

              //跳转到主页
              this.$router.replace('/Index');
            }else{
              this.confirm_disabled=false;
              alert('用户名或密码错误！');
              return false;
            }
          });
        }else{
          this.confirm_disabled=flase;
          return false;
        }
      });
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