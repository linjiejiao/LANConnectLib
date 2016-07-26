//
//  TCPServerTest.m
//  LANConnectLib
//
//  Created by liangjiajian_mac on 16/7/19.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import "TCPServer.h"
#import <sys/socket.h>
#import <netinet/in.h>

@implementation TCPServer {
     CFSocketRef socket;
}

- (BOOL)startListenOnPort:(short)port {
    _listenPort = port;
    CFSocketContext context;
    context.version = 0;
    context.info = (__bridge void *)(self);
    context.retain = nil;
    context.release = nil;
    context.copyDescription = nil;
    socket = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_STREAM, IPPROTO_TCP, kCFSocketAcceptCallBack, TCPServerAcceptCallBack, &context);
    if (NULL == socket) {
        NSLog(@"Cannot create socket!");
        return NO;
    }
    int optval = 1;
    setsockopt(CFSocketGetNative(socket), SOL_SOCKET, SO_REUSEADDR, (void *)&optval, sizeof(optval));
    struct sockaddr_in addr4;
    memset(&addr4, 0, sizeof(addr4));
    addr4.sin_len = sizeof(addr4);
    addr4.sin_family = AF_INET;
    addr4.sin_port = htons(port);
    addr4.sin_addr.s_addr = htonl(INADDR_ANY);
    CFDataRef address = CFDataCreate(kCFAllocatorDefault, (UInt8*)&addr4, sizeof(addr4));
    if (kCFSocketSuccess != CFSocketSetAddress(socket, address)) {
        NSLog(@"Bind to address failed!");
        if (socket){
            CFRelease(socket);
            socket = NULL;
        }
        return NO;
    }
    CFRunLoopRef cfRunLoop = CFRunLoopGetCurrent();
    CFRunLoopSourceRef source = CFSocketCreateRunLoopSource(kCFAllocatorDefault,socket, 0);
    CFRunLoopAddSource(cfRunLoop, source, kCFRunLoopCommonModes);
    CFRelease(source);
    if([Config sharedInstance].debug){
        NSLog(@"Bind to address succeed!");
    }
    return YES;
}

- (void)stopServer {
    if(socket){
        close(CFSocketGetNative(socket));
        CFRelease(socket);
    }
}

static void TCPServerAcceptCallBack(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void*info) {
    TCPServer *selfRef = (__bridge TCPServer *)(info);
    if(selfRef){
        [selfRef handleSocketCallback:socket type:type address:address data:data];
    }else{
        NSLog(@"TCPServerAcceptCallBack server is nil!");
    }
}

- (void)handleSocketCallback:(CFSocketRef)socket type:(CFSocketCallBackType)type address:(CFDataRef) address data:(const void *)data {
    if (kCFSocketAcceptCallBack == type) {
        CFSocketNativeHandle nativeSocketHandle = *(CFSocketNativeHandle *)data;
        TCPAcceptSection *accecptSection = [TCPAcceptSection new];
        [accecptSection initFromNativeSocketHandle:nativeSocketHandle];
        if(self.delegate){
            [self.delegate acceptConnection:accecptSection];
        }
    }else{
        NSLog(@"handleSocketCallback unhandle type:%lu", type);
    }
}
@end
