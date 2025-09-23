import vue from 'vue'
import Vuex from 'vuex'
import router, {resetRouter} from "@/router";

vue.use(Vuex)

function addNewRoute(menuList) {
    console.log(menuList)
    let routes = router.options.routes
    console.log(routes)
    //forEach循环每一条
    routes.forEach(routeItem=>{
        if(routeItem.path=="/Index"){
            menuList.forEach(menu=>{
                let childRoute =  {
                    path:'/'+menu.menuclick,
                    name:menu.menuname,
                    meta:{
                        title:menu.menuname
                    },
                    component:()=>import('../components/'+menu.menucomponent)
                }

                routeItem.children.push(childRoute)
            })
        }
    })

    resetRouter()
    router.addRoutes(routes)//将routes添加到router
}

export default new Vuex.Store({
    //定义全局属性
    state: {
        menu: []
    },
    //存放同步方法
    mutations: {
        setMenu(state,menuList) {
            state.menu = menuList
            addNewRoute(menuList)
        }
    },
    //对state的数进行计算
    getters: {
        getMenu(state) {
            return state.menu
        }
    }
})