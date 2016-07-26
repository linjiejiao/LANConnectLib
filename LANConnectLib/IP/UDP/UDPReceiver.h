//
//  UDPReceiver.h
//  LANConnectLib
//
//  Created by liangjiajian_mac on 16/7/20.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import <LANConnectLib/LANConnectLib.h>
#import "AppActiveStateBase.h"

@protocol UDPDataDelegate <NSObject>
@required
- (void)onReceiveData:(NSData*)data fromIP:(NSString*)ip port:(short)port error:(NSError*)error;
@end

@interface UDPReceiver : AppActiveStateBase
@property (weak, nonatomic) id<UDPDataDelegate> delegate;
- (instancetype)initWithLocalPort:(int)port;
- (void)close;
@end
