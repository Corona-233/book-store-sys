package com.pro.service.implement;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.pro.entity.Operation;
import com.pro.mapper.OperationMapper;
import com.pro.service.OperationService;
import org.springframework.stereotype.Service;


@Service
public class OperationServiceImpl extends ServiceImpl<OperationMapper, Operation> implements OperationService {
}
