package com.pro.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.core.toolkit.StringUtils;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.pro.common.QueryPageParam;
import com.pro.common.Result;
import com.pro.entity.Goods;
import com.pro.entity.Operation;
import com.pro.service.GoodsService;
import com.pro.service.OperationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Objects;

@RestController
@RequestMapping("/operation")
public class OperationController {

    @Autowired
    private OperationService operationService;

    @Autowired
    private GoodsService goodsService;


    //查询
    @PostMapping("/listPage")
    public Result listPage(@RequestBody QueryPageParam query){//QueryPageParam为入参封装

        HashMap param = query.getParam();
        String no = (String)param.get("no");
        String storage = (String)param.get("storage");
        String good = (String)param.get("good");
        String goodstype = (String)param.get("goodstype");
        String type = (String)param.get("type");

        Page<Operation> page = new Page<>();//current:当前页；size:每页条数
        page.setCurrent(query.getPageNum());
        page.setSize(query.getPageSize());


        LambdaQueryWrapper<Operation> lambdaQueryWrapper = new LambdaQueryWrapper();
        //按订单号查询
        if(StringUtils.isNotBlank(no) && !"null".equals(no)){//如果no不为空
            lambdaQueryWrapper.like(Operation::getNo, no);
        }
        //按仓库查询
        if(StringUtils.isNotBlank(storage) && !"null".equals(storage)){//如果storage不为空
            lambdaQueryWrapper.eq(Operation::getStorage,storage);
        }
        //按商品查询
        if(StringUtils.isNotBlank(good) && !"null".equals(good)){//如果good不为空
            lambdaQueryWrapper.like(Operation::getGood, good);
        }
        //按商品类别查询
        if(StringUtils.isNotBlank(goodstype) && !"null".equals(goodstype)){//如果goodstype不为空
            lambdaQueryWrapper.eq(Operation::getGoodstype, goodstype);
        }
        //按出入库类别查询
        if(StringUtils.isNotBlank(type) && !"null".equals(type)){//type
            lambdaQueryWrapper.eq(Operation::getType, type);
        }

        IPage<Operation> result = operationService.page(page,lambdaQueryWrapper);

        return Result.suc(result.getTotal(),result.getRecords());
    }

    //删除操作记录
    @Transactional
    @GetMapping("/del")
    public Result del(@RequestParam String id){

        // 根据ID获取操作记录
        Operation operation = operationService.getById(id);
        Goods goods = goodsService.getByName(operation.getGood());

        // 判断操作类型："1"代表出库操作
        if(Objects.equals(operation.getType(), "1")) {
            // 出库删除：将商品数量加上操作数量（回滚出库操作）
            goods.setCount(goods.getCount() + operation.getCount());
        } else {
            // 出库删除：将商品数量减去操作数量（回滚入库操作）
            goods.setCount(goods.getCount() - operation.getCount());
        }

        goodsService.updateById(goods);
        return operationService.removeById(id) ? Result.suc() : Result.fail();
    }

    //添加操作记录
    @Transactional
    @PostMapping("/save")
    public Result save(@RequestBody Operation operation){

        // 根据操作记录中的商品名称查询商品信息
        Goods goods = goodsService.getByName(operation.getGood());

        // 判断商品是否存在
        if (goods == null){
            // 商品不存在的情况处理

            // 如果是出库操作（类型为"1"），商品不存在则直接返回失败
            // 因为不能对不存在的商品进行出库操作
            if(Objects.equals(operation.getType(), "1")){
                return Result.fail();
            }else {
                // 入库操作（类型非"1"）：创建新商品

                // 创建商品对象并设置属性
                Goods good = new Goods();
                good.setName(operation.getGood());        // 设置商品名称
                good.setStorage(operation.getStorage());  // 设置仓库信息
                good.setGoodstype(operation.getGoodstype()); // 设置商品类型
                good.setCount(operation.getCount());      // 设置商品数量

                // 保存新商品到数据库
                boolean goodsSaved = goodsService.save(good);
                if (!goodsSaved) {
                    return Result.fail(); // 商品保存失败，返回错误
                }
            }
        }else {
            // 商品已存在，更新商品库存数量

            // 判断操作类型：出库操作（类型为"1"）
            if(Objects.equals(operation.getType(), "1")){
                // 检查库存是否充足
                if(goods.getCount() >= operation.getCount()){
                    goods.setCount(goods.getCount() - operation.getCount()); // 出库：减少库存数量
                }else {
                    return Result.fail(); // 库存不足，返回失败
                }
            }else {
                // 入库操作（类型非"1"）
                goods.setCount(goods.getCount() + operation.getCount()); // 入库：增加库存数量
            }

            // 更新商品库存信息
            goodsService.updateById(goods);
        }

        // 保存操作记录并返回结果
        return operationService.save(operation) ? Result.suc() : Result.fail();
    }

    //修改操作记录
    @Transactional
    @PostMapping("/update")
    public Result update(@RequestBody Operation operation){

        // 根据ID获取原始操作记录
        Operation operation1 = operationService.getById(operation.getId());

        // 根据商品名称获取商品信息
        Goods goods = goodsService.getByName(operation.getGood());

        // 判断操作类型："1"代表出库操作
        if(Objects.equals(operation.getType(), "1")) {
            // 出库修改：调整商品数量
            // 公式：当前库存 - (新出库数量 - 原出库数量)
            // 相当于先回滚原出库操作，再应用新出库操作
            goods.setCount(goods.getCount() - operation.getCount() + operation1.getCount());
        } else {
            // 入库修改：调整商品数量
            // 公式：当前库存 + (新入库数量 - 原入库数量)
            // 相当于先回滚原入库操作，再应用新入库操作
            goods.setCount(goods.getCount() + operation.getCount() - operation1.getCount());
        }

        // 更新商品库存数量
        goodsService.updateById(goods);

        // 更新操作记录并返回结果
        return operationService.updateById(operation) ? Result.suc() : Result.fail();
    }

}
