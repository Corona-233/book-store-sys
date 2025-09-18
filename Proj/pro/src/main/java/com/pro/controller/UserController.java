package com.pro.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.core.toolkit.StringUtils;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.pro.common.QueryPageParam;
import com.pro.common.Result;
import com.pro.entity.Menu;
import com.pro.entity.User;
import com.pro.service.MenuService;
import com.pro.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;


import java.util.HashMap;
import java.util.List;

@RestController
@RequestMapping("/user")
public class UserController {

    @Autowired//自动注入，注入后即可使用该属性
    private UserService userService;

    @Autowired
    private MenuService menuService;

    @GetMapping("/list")//用于定义HTTP GET请求的URL路径。当客户端发送HTTP GET请求时，Spring Boot会自动将请求映射到具有相应URL路径的控制器方法上。
    public List<User> list(){
       return userService.list();
   }

    //登录
    @PostMapping("/login")//用于处理 HTTP POST 请求
    public Result login(@RequestBody User user){
        List list = userService.lambdaQuery().eq(User::getNo,user.getNo()).eq(User::getPassword,user.getPassword()).list();

        if(list.size()>0){
            User user1 = (User)list.get(0);
            List menuList = menuService.lambdaQuery().like(Menu::getMenuright,user1.getRoleId()).list();
            HashMap res = new HashMap();
            res.put("user",user1);
            res.put("menu",menuList);
            return Result.suc(res);
        }
        return Result.fail();
    }


    //新增
    @PostMapping("/save")
    public Result save(@RequestBody User user){
        return userService.save(user)?Result.suc():Result.fail();
    }

    //修改
    @PostMapping("/update")
    public Result update(@RequestBody User user){
        return userService.updateById(user)?Result.suc():Result.fail();
    }

    //删除
    @GetMapping("/del")
    public Result del(@RequestParam String id){
        return userService.removeById(id)?Result.suc():Result.fail();
    }

    //验证帐号唯一性
    @GetMapping("/findByNo")
    public Result findByNo(@RequestParam String no){
       List list = userService.lambdaQuery().eq(User::getNo,no).list();
       return list.size()>0?Result.suc(list):Result.fail();
    }


    @PostMapping("/listPage")
    public Result listPage(@RequestBody QueryPageParam query){//QueryPageParam为入参封装
        HashMap param = query.getParam();
        String name = (String)param.get("name");
        String sex = (String)param.get("sex");
        String roleId = (String)param.get("roleId");

        Page<User> page = new Page();//current:当前页；size:每页条数
        page.setCurrent(query.getPageNum());
        page.setSize(query.getPageSize());

        //按姓名查询
        LambdaQueryWrapper<User> lambdaQueryWrapper = new LambdaQueryWrapper();
        if(StringUtils.isNotBlank(name) && !"null".equals(name)){//如果name不为空
            lambdaQueryWrapper.like(User::getName,name);
        }

        //按性别查询
        if(StringUtils.isNotBlank(sex)){//如果name不为空
            lambdaQueryWrapper.eq(User::getSex,sex);
        }

        //按权限查询
        if(StringUtils.isNotBlank(roleId)){
            lambdaQueryWrapper.eq(User::getRoleId,roleId);
        }

        IPage result = userService.page(page,lambdaQueryWrapper);

        return Result.suc(result.getTotal(),result.getRecords());
    }

}
