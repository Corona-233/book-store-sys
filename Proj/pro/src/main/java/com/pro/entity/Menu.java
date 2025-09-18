package com.pro.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import lombok.Data;
@Data
public class Menu {

    private Integer id;


    @TableField("menuCode")
    private String menucode;


    @TableField("menuName")
    private String menuname;


    @TableField("menuLevel")
    private String menulevel;


    @TableField("menuParentCode")
    private String menuparentcode;


    @TableField("menuClick")
    private String menuclick;


    @TableField("menuRight")
    private String menuright;

    @TableField("menuComponent")
    private String menucomponent;

    @TableField("menuIcon")
    private String menuicon;
}