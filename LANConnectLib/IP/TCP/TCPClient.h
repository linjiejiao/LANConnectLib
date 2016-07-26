//
//  TCPTest.h
//  LANConnectLib
//
//  Created by liangjiajian_mac on 16/7/19.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCPSection.h"

@interface TCPClient : TCPSection

- (BOOL)connectTo:(NSString*)ip port:(short)port;

@end
