//
//  TCPClient.m
//  LANConnectLib
//
//  Created by liangjiajian_mac on 16/7/19.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import "TCPClient.h"

@implementation TCPClient

- (BOOL)connectTo:(NSString*)ip port:(short)port{
    self.remoteIp = ip;
    self.remotePort = port;
    return [self open];
}

- (BOOL)initStreams{
    if(!self.remoteIp || self.remoteIp.length < 7 || self.remoteIp == 0){
        return NO;
    }
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)self.remoteIp, self.remotePort, &readStream, &writeStream);
    self.inputStream = (__bridge NSInputStream *)readStream;
    self.outputStream = (__bridge NSOutputStream *)writeStream;
    return YES;
}

@end
