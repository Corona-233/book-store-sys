package com.pro.service.implement;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.pro.entity.User;
import com.pro.mapper.UserMapper;
import com.pro.service.UserService;
import org.springframework.stereotype.Service;

@Service
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements UserService {

}
