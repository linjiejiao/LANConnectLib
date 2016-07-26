//
//  TCPAcceptSection.m
//  LANConnectLib
//
//  Created by liangjiajian_mac on 16/7/22.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import "TCPAcceptSection.h"
#import <sys/socket.h>
#import <arpa/inet.h>

@implementation TCPAcceptSection {
    CFSocketNativeHandle nativeSocketHandle;
}

- (BOOL)initFromNativeSocketHandle:(CFSocketNativeHandle)handle {
    nativeSocketHandle = handle;
    uint8_t name[SOCK_MAXADDRLEN];
    socklen_t nameLen = sizeof(name);
    if (0 != getpeername(nativeSocketHandle, (struct sockaddr *)name,&nameLen)) {
        NSLog(@"error");
        exit(1);
    }
    NSLog(@"%s connected.", inet_ntoa( ((struct sockaddr_in*)name)->sin_addr ));
    return YES;
}

- (BOOL)initStreams{
    if(!nativeSocketHandle){
        return NO;
    }
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocket(NULL, nativeSocketHandle, &readStream, &writeStream);
    self.inputStream = (__bridge NSInputStream *)readStream;
    self.outputStream = (__bridge NSOutputStream *)writeStream;
    return YES;
}

@end
