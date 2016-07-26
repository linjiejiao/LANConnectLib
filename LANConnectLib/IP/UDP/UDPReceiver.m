//
//  UDPReceiver.m
//  LANConnectLib
//
//  Created by liangjiajian_mac on 16/7/20.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import "UDPReceiver.h"
#import <arpa/inet.h>
#import <UIKit/UIKit.h>

@implementation UDPReceiver {
    CFSocketRef socket;
    short listenPort;
}

- (instancetype)init{
    self = [super init];
    if(self){
        [self initReceiver];
    }
    return self;
}

- (instancetype)initWithLocalPort:(int)port {
    self = [super init];
    if(self){
        [self initReceiver];
        [self bindOnLocalPort:port];
    }
    return self;
}

- (void)bindOnLocalPort:(int)port {
    listenPort = port;
    [self checkSocket];
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

- (void)close {
    if(socket){
        close(CFSocketGetNative(socket));
        CFRelease(socket);
        socket = NULL;
    }
}

#pragma mark - common method
- (void)checkSocket{
    if (!socket) {
        NSLog(@"Cannot create socket!");
        @throw [[NSException alloc]initWithName:@"initReceiver Exception" reason:@"Cannot create socket!" userInfo:nil];
        return;
    }
}

- (void)initReceiver {
    CFSocketContext context;
    context.version = 0;
    context.info = (__bridge void *)(self);
    context.retain = nil;
    context.release = nil;
    context.copyDescription = nil;
    socket = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_DGRAM, IPPROTO_UDP, kCFSocketReadCallBack, UDPReadCallback, &context);
    [self checkSocket];
    int optval = 1;
    setsockopt(CFSocketGetNative(socket), SOL_SOCKET, SO_REUSEADDR, (void *)&optval, sizeof(optval));
    CFRunLoopRef cfRunLoop = CFRunLoopGetCurrent();
    CFRunLoopSourceRef source = CFSocketCreateRunLoopSource(kCFAllocatorDefault, socket, 0);
    CFRunLoopAddSource(cfRunLoop, source, kCFRunLoopCommonModes);
    CFRelease(source);
    [self registerStateListener];
}

static void UDPReadCallback(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void*info) {    UDPReceiver *ocSelf = (__bridge UDPReceiver *)(info);
    if([Config sharedInstance].debug){
        NSLog(@"UDPReadCallback type=%ld", type);
    }
    if(ocSelf){
        [ocSelf handleSocketCallback:socket type:type address:address data:data];
    }
}

- (void)handleSocketCallback:(CFSocketRef)socketRef type:(CFSocketCallBackType)type address:(CFDataRef) address data:(const void *)data {
    if(kCFSocketReadCallBack == type) {
        char buffer[UDP_BUFFER_SIZE];
        socklen_t addrLen;
        struct sockaddr_in addr;
        addrLen = sizeof(struct sockaddr); // important!
        long bytesRead = recvfrom(CFSocketGetNative(socketRef), buffer, UDP_BUFFER_SIZE, 0, (struct sockaddr *)&addr, &addrLen);
        if(bytesRead > 0){
            NSData *dataObj = [NSData dataWithBytes:buffer length:bytesRead];
            if(self.delegate){
                [self.delegate onReceiveData:dataObj fromIP:[NSString stringWithUTF8String:inet_ntoa(addr.sin_addr)] port:ntohs(addr.sin_port) error:nil];
            }
        }
    }
}

#pragma mark - override
- (void)becomeActive{
    if(socket) {
        return;
    }
    [self initReceiver];
    if(listenPort > 0){
        [self bindOnLocalPort:listenPort];
    }
}

- (void)resignActive {
    [self close];
}

- (void)dealloc {
    [self close];
}
@end
