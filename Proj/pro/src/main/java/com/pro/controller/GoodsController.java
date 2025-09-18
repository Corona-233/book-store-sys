package com.pro.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.core.toolkit.StringUtils;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.pro.common.QueryPageParam;
import com.pro.common.Result;
import com.pro.entity.Goods;
import com.pro.service.GoodsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.HashMap;


@RestController
@RequestMapping("/goods")
public class GoodsController {
    @Autowired
    private GoodsService goodsService;

    //新增
    @PostMapping("/save")
    public Result save(@RequestBody Goods goods){
        return goodsService.save(goods)?Result.suc():Result.fail();
    }

    //修改
    @PostMapping("/update")
    public Result update(@RequestBody Goods goods){
        return goodsService.updateById(goods)?Result.suc():Result.fail();
    }

    //删除
    @GetMapping("/del")
    public Result del(@RequestParam String id){
        return goodsService.removeById(id)?Result.suc():Result.fail();
    }

    @PostMapping("/listPage")
    public Result listPage(@RequestBody QueryPageParam query){//QueryPageParam为入参封装
        HashMap param = query.getParam();
        String name = (String)param.get("name");
        String storage = (String)param.get("storage");
        String goodstype = (String)param.get("goodstype");

        Page<Goods> page = new Page();//current:当前页；size:每页条数
        page.setCurrent(query.getPageNum());
        page.setSize(query.getPageSize());

        //按姓名查询
        LambdaQueryWrapper<Goods> lambdaQueryWrapper = new LambdaQueryWrapper();
        //按名称查询
        if(StringUtils.isNotBlank(name) && !"null".equals(name)){//如果name不为空
            lambdaQueryWrapper.like(Goods::getName,name);
        }
        //按书库查询
        if(StringUtils.isNotBlank(storage) && !"null".equals(storage)){//如果name不为空
            lambdaQueryWrapper.eq(Goods::getStorage,storage);
        }
        //按类型查询
        if(StringUtils.isNotBlank(goodstype) && !"null".equals(goodstype)){//如果name不为空
            lambdaQueryWrapper.eq(Goods::getGoodstype,goodstype);
        }


        IPage result = goodsService.page(page,lambdaQueryWrapper);

        return Result.suc(result.getTotal(),result.getRecords());
    }
}
