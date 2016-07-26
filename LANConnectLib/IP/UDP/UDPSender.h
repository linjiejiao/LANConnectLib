//
//  UDPSender.h
//  LANConnectLib
//
//  Created by liangjiajian_mac on 16/7/20.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppActiveStateBase.h"

@interface UDPSender : AppActiveStateBase
- (instancetype)initWithLocalPort:(short)port;
- (void)sendData:(NSData*)data toIp:(NSString*)ip port:(short)port;
- (void)close;

@end
