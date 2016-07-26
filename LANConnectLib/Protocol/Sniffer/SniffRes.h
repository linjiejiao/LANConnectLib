//
//  SniffRes.h
//  LANConnectLib
//
//  Created by liangjiajian_mac on 16/7/23.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Terminal.h"
#import "PackageUtil.h"

@interface SniffRes : NSObject <PackageProtocol>
@property (nonatomic, assign) int seqId;
@property (nonatomic, strong) Terminal *terminal;

@end
