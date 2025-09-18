<script>
  export default {
    name: "Header",
    data(){
      return {
        user :JSON.parse(sessionStorage.getItem('CurUser'))
      }
    },
    methods:{
      toUser(){
        this.$router.push("/Home")
      },
      logout(){
        this.$confirm('您确定要退出登录吗？',{
          confirmButtonText: '确定',
          type: 'warning',
          center: true
        })
          .then(() => {
            this.$message({
              type: 'success',
              message: '成功退出登录'
            })
            this.$router.push("/")
            sessionStorage.clear()
          })
          .catch(() => {
            this.$message({
              type: 'info',
              message: '已取消'
            })
          })
      },
      collapse(){
        this.$emit('doCollapse')
      }
    },
    created(){
      this.$router.push("/Home")
    },
    props:{
      icon:String
    }
  }
</script>

<template>
  <div style="display: flex; line-height: 60px">
    <div>
      <!--  左侧菜单图标  -->
      <i :class="icon" style="font-size: 18px;line-height: 60px" @click="collapse"></i>
    </div>
    <div style="flex: 1; text-align: center; font-size: 18px">
      <span>欢迎</span>
    </div>
    <span>{{ user.name }}</span>
    <el-dropdown>
      <!--  顶部用户图标  -->
      <i class="el-icon-arrow-down" style="font-size: 18px;margin-left: 10px"></i>
      <el-dropdown-menu slot="dropdown">
        <el-dropdown-item @click.native="toUser">个人中心</el-dropdown-item>
        <el-dropdown-item @click.native="logout">退出登录</el-dropdown-item>
      </el-dropdown-menu>
    </el-dropdown>
  </div>
</template>

<style scoped>

</style>