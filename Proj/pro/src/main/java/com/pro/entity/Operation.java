package com.pro.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import lombok.Data;

@Data
public class Operation {

    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;
    private String no;
    private String good;
    private Integer goodstype;
    private Integer count;
    private Integer storage;
    private String type;

}
