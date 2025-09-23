package com.pro.service.implement;

import com.pro.entity.Menu;
import com.pro.mapper.MenuMapper;
import com.pro.service.MenuService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

@Service
public class MenuServiceImpl extends ServiceImpl<MenuMapper, Menu> implements MenuService {

}
