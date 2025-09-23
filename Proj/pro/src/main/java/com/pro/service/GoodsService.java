package com.pro.service;

import com.pro.entity.Goods;
import com.baomidou.mybatisplus.extension.service.IService;

public interface GoodsService extends IService<Goods> {

    Goods getByName(String goodName);
}