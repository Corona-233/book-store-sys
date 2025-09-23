//入参封装
package com.pro.common;

import lombok.Data;

import java.util.HashMap;

@Data
public class QueryPageParam {
    //默认值
    private static int PAGE_SIZE=20;//共计20页
    private static int PAGE_NUM=1;//默认第1页

    private int pageSize = PAGE_SIZE;
    private int pageNum = PAGE_NUM=1;

    private HashMap param = new HashMap();
}
