//
//  SnifferManager.h
//  LANConnectLib
//
//  Created by liangjiajian_mac on 16/7/22.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Terminal.h"

typedef void (^SniffResultCallBack)(NSArray *terminals);
@interface SnifferManager : NSObject
@property (nonatomic, assign) BOOL respondSniffReq;
+ (SnifferManager*)shareInstance;

- (void)startSniffing:(SniffResultCallBack)callback;

@end
