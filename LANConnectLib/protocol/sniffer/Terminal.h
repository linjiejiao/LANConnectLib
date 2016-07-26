//
//  Terminal.h
//  LANConnectLib
//
//  Created by liangjiajian_mac on 16/7/22.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PackageUtil.h"
#import "Defines.h"

@interface Terminal : NSObject <PackageProtocol>
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *ipAddress;
@property (nonatomic, assign) short tcpServerPort;
@property (nonatomic, assign) short udpServerPort;

@end
