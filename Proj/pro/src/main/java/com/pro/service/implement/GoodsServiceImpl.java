package com.pro.service.implement;

import com.pro.entity.Goods;
import com.pro.mapper.GoodsMapper;
import com.pro.service.GoodsService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class GoodsServiceImpl extends ServiceImpl<GoodsMapper, Goods> implements GoodsService {

    @Autowired
    GoodsMapper goodsMapper;

    @Override
    public Goods getByName(String goodName) {
        return goodsMapper.selectByName(goodName);
    }
}