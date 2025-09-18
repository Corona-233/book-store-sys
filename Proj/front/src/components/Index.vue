<script>
  import Aside from "@/components/Aside.vue";
  import Header from "@/components/Header.vue";


  export default {
    name: "Index",
    components: { Header, Aside},
    data(){
      return{
        isCollapse:false,
        aside_width:'200px',
        icon:'el-icon-s-fold'
      }
    },
    methods:{
      doCollapse(){
        this.isCollapse = !this.isCollapse
        if(!this.isCollapse){//展开
          this.aside_width = '200px'
          this.icon = 'el-icon-s-fold'
        }
        else{//收起
          this.aside_width = '64px'
          this.icon = 'el-icon-s-unfold'
        }
      }
    }
  };
</script>

<template>
  <el-container style="height: 100%; border: 1px solid #eee">
    <!----------------------------------------------------  左侧菜单  ---------------------------------------------------->
    <el-aside :width="aside_width" style="background-color: rgb(238, 241, 246) ;margin-left: -1px; margin-bottom: -1px;height: 100vh">
      <Aside :isCollapse="isCollapse"></Aside>
    </el-aside>

    <el-container style="height: 100%">
      <!----------------------------------------------------  顶部信息  ---------------------------------------------------->
      <el-header style="text-align: right; font-size: 12px; height: 100%; border-bottom: rgba(51,51,51,0.24) 2px solid">
        <Header @doCollapse="doCollapse" :icon="icon"></Header>
      </el-header>

      <!----------------------------------------------------  主要数据  ---------------------------------------------------->
      <el-main style="height: 100%">
        <router-view/>
      </el-main>
    </el-container>
  </el-container>
</template>

<style scoped>
  #.el-header {
    background-color: #B3C0D1;
    color: #333;
    line-height: 60px;
  }

  .el-main{
    padding: 5px;
  }

  .el-aside {
    color: #333;
  }
</style>