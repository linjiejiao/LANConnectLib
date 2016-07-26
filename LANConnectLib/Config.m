//
//  Config.m
//  LANConnectLib
//
//  Created by liangjiajian_mac on 16/7/21.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import "Config.h"

@implementation Config
static Config *_instance;

+ (Config*)sharedInstance {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _instance = [Config new];
        _instance.debug = YES;
    });
    return _instance;
}

@end
