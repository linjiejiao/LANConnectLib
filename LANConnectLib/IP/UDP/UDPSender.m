//
//  UDPSender.m
//  LANConnectLib
//
//  Created by liangjiajian_mac on 16/7/20.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import "UDPSender.h"
#import <arpa/inet.h>

@implementation UDPSender {
    CFSocketRef socket;
    short localPort;
}

- (instancetype)init {
    self = [super init];
    if(self){
        [self initSender];
    }
    return self;
}

- (instancetype)initWithLocalPort:(short)port {
    self = [super init];
    if(self){
        [self initSender];
        [self setSendingLocalPort:port];
    }
    return self;
}

- (void)setSendingLocalPort:(short)port {
    localPort = port;
    struct sockaddr_in addr4;
    memset(&addr4, 0, sizeof(addr4));
    addr4.sin_len = sizeof(addr4);
    addr4.sin_family = AF_INET;
    addr4.sin_port = htons(port);
    addr4.sin_addr.s_addr = htonl(INADDR_ANY);
    int ret = bind(CFSocketGetNative(socket), (const struct sockaddr *) &addr4, sizeof(addr4));
    if (0 != ret) {
        NSLog(@"Bind to local port:%u failed! ret=%d", port , ret);
        return;
    }
}

- (void)sendData:(NSData*)data toIp:(NSString*)ip port:(short)port {
    [self checkSocket];
    struct sockaddr_in addr4;
    memset(&addr4, 0, sizeof(addr4));
    addr4.sin_len = sizeof(addr4);
    addr4.sin_family = AF_INET;
    addr4.sin_port = htons(port);
    addr4.sin_addr.s_addr = inet_addr([ip cStringUsingEncoding:NSUTF8StringEncoding]);
    CFDataRef address = CFDataCreate(kCFAllocatorDefault, (UInt8*)&addr4, sizeof(addr4));
    CFSocketSendData(socket, address, (CFDataRef )data, 5);
}


- (void)close {
    if(socket){
        close(CFSocketGetNative(socket));
        CFRelease(socket);
        socket = NULL;
    }
}

#pragma mark - common method
- (void)initSender {
    socket = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_DGRAM, IPPROTO_UDP, kCFSocketNoCallBack, NULL, nil);
    [self checkSocket];
    int optval = 1;
    setsockopt(CFSocketGetNative(socket), SOL_SOCKET, SO_BROADCAST, (void *)&optval, sizeof(optval));
    CFRunLoopRef cfRunLoop = CFRunLoopGetCurrent();
    CFRunLoopSourceRef source = CFSocketCreateRunLoopSource(kCFAllocatorDefault, socket, 0);
    CFRunLoopAddSource(cfRunLoop, source, kCFRunLoopCommonModes);
    CFRelease(source);
    [self registerStateListener];
}

- (void)checkSocket{
    if (!socket) {
        NSLog(@"Cannot create socket!");
        @throw [[NSException alloc]initWithName:@"initReceiver Exception" reason:@"Cannot create socket!" userInfo:nil];
        return;
    }
}

#pragma mark - override
- (void)becomeActive {
    if(socket){
        return;
    }
    [self initSender];
    if(localPort > 0){
        [self setSendingLocalPort:localPort];
    }
}

- (void)resignActive {
    [self close];
}

- (void)dealloc {
    [self close];
}

@end
