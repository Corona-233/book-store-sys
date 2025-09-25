package com.pro.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.core.toolkit.StringUtils;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.pro.common.QueryPageParam;
import com.pro.common.Result;
import com.pro.entity.Goods;
import com.pro.entity.Goodstype;
import com.pro.service.GoodsService;
import com.pro.service.GoodstypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.HashMap;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.stream.Collectors;


@RestController
@RequestMapping("/goods")
public class GoodsController {
    @Autowired
    private GoodsService goodsService;

    @Autowired
    private GoodstypeService goodstypeService;

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


        LambdaQueryWrapper<Goods> lambdaQueryWrapper = new LambdaQueryWrapper();
        //按名称查询
        if(StringUtils.isNotBlank(name) && !"null".equals(name)){//如果name不为空
            lambdaQueryWrapper.like(Goods::getName,name);
        }
        //按仓库查询
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

    // 获取商品名称建议
    @GetMapping("/nameSuggestions")
    public Result getNameSuggestions(@RequestParam String keyword){
        if(StringUtils.isBlank(keyword)){
            return Result.suc(new ArrayList<>());
        }
        
        // 查询包含关键词的商品名称
        List<Goods> goodsList = goodsService.lambdaQuery()
            .like(Goods::getName, keyword)
            .select(Goods::getName)
            .list();
        
        // 提取商品名称并去重
        List<String> nameList = goodsList.stream()
            .map(Goods::getName)
            .distinct()
            .collect(Collectors.toList());
        
        return Result.suc(nameList);
    }

    // 获取商品类型映射关系
    @GetMapping("/typeMapping")
    public Result getTypeMapping(){
        // 查询所有商品及其类型
        List<Goods> goodsList = goodsService.list();
        
        // 查询所有商品类型
        List<Goodstype> goodstypeList = goodstypeService.list();
        Map<Integer, String> typeIdToNameMap = goodstypeList.stream()
            .collect(Collectors.toMap(Goodstype::getId, Goodstype::getName));
        
        // 构建商品名称到类型的映射
        Map<String, String> mapping = new HashMap<>();
        for(Goods goods : goodsList){
            if(StringUtils.isNotBlank(goods.getName()) && goods.getGoodstype() != null){
                String typeName = typeIdToNameMap.get(goods.getGoodstype());
                if(StringUtils.isNotBlank(typeName)){
                    mapping.put(goods.getName(), typeName);
                }
            }
        }
        
        return Result.suc(mapping);
    }
}
