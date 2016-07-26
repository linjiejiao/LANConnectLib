//
//  Terminal.m
//  LANConnectLib
//
//  Created by liangjiajian_mac on 16/7/22.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import "Terminal.h"
#import "PackageUtil.h"

@implementation Terminal
- (int)size {
    return [PackageUtil calculateStringSize:self.name]
    + [PackageUtil calculateStringSize:self.ipAddress] + 4;
}

- (BOOL)packToBuffer:(ByteBuffer*)buffer {
    [PackageUtil packString:self.name buffer:buffer];
    [PackageUtil packString:self.ipAddress buffer:buffer];
    [buffer putShort:self.tcpServerPort];
    [buffer putShort:self.udpServerPort];
    return YES;
}

- (BOOL)unPackFromBuffer:(ByteBuffer*)buffer {
    self.name = [PackageUtil unPackString:buffer];
    self.ipAddress = [PackageUtil unPackString:buffer];
    self.tcpServerPort = [buffer getShort];
    self.udpServerPort = [buffer getShort];
    return YES;
}

- (BOOL)isEqual:(id)object {
    if(![object isKindOfClass:[Terminal class]]){
        return NO;
    }
    Terminal *other = object;
    if([self.ipAddress isEqualToString:other.ipAddress]
       && self.tcpServerPort == other.tcpServerPort
       && self.udpServerPort == other.udpServerPort){
        return YES;
    }
    return NO;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Terminal[name=%@, ipAddress=%@, tcpServerPort=%d, udpServerPort=%d]", self.name, self.ipAddress, self.tcpServerPort, self.udpServerPort];
}
@end
