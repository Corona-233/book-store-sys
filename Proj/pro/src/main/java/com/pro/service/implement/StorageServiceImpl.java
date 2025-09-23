package com.pro.service.implement;

import com.pro.entity.Storage;
import com.pro.mapper.StorageMapper;
import com.pro.service.StorageService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

@Service
public class StorageServiceImpl extends ServiceImpl<StorageMapper, Storage> implements StorageService {

}