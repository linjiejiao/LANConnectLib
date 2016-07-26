//
//  LocalIPUtils.m
//  LANConnectLib
//
//  Created by liangjiajian_mac on 16/7/25.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import "LocalIPUtils.h"
#import <ifaddrs.h>
#import <arpa/inet.h>

@implementation LocalIPUtils

+ (struct ifaddrs *)getWifiAddress {
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    return temp_addr;
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return NULL;
}

+ (NSString*)getIPAddress {
    NSString *address = @"";
    struct ifaddrs *temp_addr = [LocalIPUtils getWifiAddress];
    if(temp_addr != NULL) {
        address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
    }
    return address;
}

+ (NSString *)getNetworkMask {
    NSString *mask = @"";
    struct ifaddrs *temp_addr = [LocalIPUtils getWifiAddress];
    if(temp_addr != NULL) {
        mask = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr)];
    }
    return mask;
}

+ (NSString *)getBroadcastAdress {
    NSString *address = @"";
    struct ifaddrs *temp_addr = [LocalIPUtils getWifiAddress];
    if(temp_addr != NULL) {
        struct sockaddr	*ifa_netmask = (struct sockaddr_in *)(struct sockaddr_in *)temp_addr->ifa_addr;
        struct in_addr sin_addr = ((struct sockaddr_in *)ifa_netmask)->sin_addr;
        int ip = sin_addr.s_addr;
        ifa_netmask = (struct sockaddr_in *)(struct sockaddr_in *)temp_addr->ifa_netmask;
        sin_addr = ((struct sockaddr_in *)ifa_netmask)->sin_addr;
        int mask = sin_addr.s_addr;
        struct in_addr broadcastAddr;
        broadcastAddr.s_addr = (ip | (~mask));
        address = [NSString stringWithUTF8String:inet_ntoa(broadcastAddr)];
    }
    return address;
}

@end
