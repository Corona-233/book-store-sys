package com.pro.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.core.toolkit.StringUtils;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.pro.common.QueryPageParam;
import com.pro.common.Result;
import com.pro.entity.Menu;
import com.pro.entity.Storage;
import com.pro.service.StorageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;

@RestController
@RequestMapping("/storage")
public class StorageController {

    @Autowired
    private StorageService storageService;

    //新增
    @PostMapping("/save")
    public Result save(@RequestBody Storage storage){
        return storageService.save(storage)?Result.suc():Result.fail();
    }

    //修改
    @PostMapping("/update")
    public Result update(@RequestBody Storage storage){
        return storageService.updateById(storage)?Result.suc():Result.fail();
    }

    //删除
    @GetMapping("/del")
    public Result del(@RequestParam String id){
        return storageService.removeById(id)?Result.suc():Result.fail();
    }

    @PostMapping("/listPage")
    public Result listPage(@RequestBody QueryPageParam query){//QueryPageParam为入参封装
        HashMap param = query.getParam();
        String name = (String)param.get("name");

        Page<Storage> page = new Page();//current:当前页；size:每页条数
        page.setCurrent(query.getPageNum());
        page.setSize(query.getPageSize());

        //按姓名查询
        LambdaQueryWrapper<Storage> lambdaQueryWrapper = new LambdaQueryWrapper();
        if(StringUtils.isNotBlank(name) && !"null".equals(name)){//如果name不为空
            lambdaQueryWrapper.like(Storage::getName,name);
        }


        IPage result = storageService.page(page,lambdaQueryWrapper);

        return Result.suc(result.getTotal(),result.getRecords());
    }

    //获取storage的所有数据
    @GetMapping("/list")
    public Result list(){
        List list = storageService.list();
        return Result.suc(list);
    }
}
