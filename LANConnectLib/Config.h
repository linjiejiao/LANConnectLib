//
//  Config.h
//  LANConnectLib
//
//  Created by liangjiajian_mac on 16/7/21.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UDP_BUFFER_SIZE 10240
#define TCP_BUFFER_SIZE 10240
#define GLOBAL_LISTEN_TCP_PORT 8080
#define GLOBAL_LISTEN_UDP_PORT 8080
#define SNIFF_UDP_PORT 6666

@interface Config : NSObject
@property (nonatomic, assign) BOOL debug;
@property (nonatomic, copy) NSString *name;

+ (Config*)sharedInstance;

@end
