package com.pro.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import lombok.Data;

@Data
@TableName("goodsType")
public class Goodstype {
    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;
    private String name;
    private String remark;
}