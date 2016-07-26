//
//  AppActiveStateBase.h
//  LANConnectLib
//
//  Created by liangjiajian_mac on 16/7/25.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppActiveStateBase : NSObject
- (void)registerStateListener;
- (void)resignStateListener;
- (void)becomeActive;
- (void)resignActive;
@end
