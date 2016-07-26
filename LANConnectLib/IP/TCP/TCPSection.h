//
//  TCPSection.h
//  LANConnectLib
//
//  Created by liangjiajian_mac on 16/7/22.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCPDataDelegate.h"
#import "Config.h"

@interface TCPSection : NSObject <NSStreamDelegate>
@property (strong, nonatomic) NSOutputStream *outputStream;
@property (strong, nonatomic) NSInputStream *inputStream;
@property (nonatomic, weak) id<TCPDataDelegate> delegate;
@property (nonatomic, assign, readonly) BOOL isConnected;
@property (nonatomic, assign, readonly) BOOL canRead;
@property (nonatomic, assign, readonly) BOOL canWrite;
@property (nonatomic, copy) NSString *remoteIp;
@property (nonatomic, assign) short remotePort;

- (BOOL)initStreams;
- (BOOL)open;
- (void)close;
- (int)sendData:(NSData*)data;

@end
