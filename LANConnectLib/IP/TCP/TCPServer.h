//
//  TCPServerTest.h
//  LANConnectLib
//
//  Created by liangjiajian_mac on 16/7/19.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCPAcceptSection.h"

@protocol TCPServerDelegate <NSObject>
@required
- (void)acceptConnection:(TCPAcceptSection*) section;
@end

@interface TCPServer : NSObject
@property (nonatomic, weak) id<TCPServerDelegate> delegate;
@property (nonatomic, assign, readonly) short listenPort;

- (BOOL)startListenOnPort:(short)port;
- (void)stopServer;

@end
