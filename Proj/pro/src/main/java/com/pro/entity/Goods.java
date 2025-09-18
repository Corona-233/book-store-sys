package com.pro.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableField;
import lombok.Data;



@Data
public class Goods {
    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;
    private String name;
    private Integer storage;
    @TableField("goodsType")
    private Integer goodstype;
    private Integer count;
    private String remark;
}
