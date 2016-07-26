//
//  TCPAcceptSection.h
//  LANConnectLib
//
//  Created by liangjiajian_mac on 16/7/22.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCPSection.h"

@interface TCPAcceptSection : TCPSection

- (BOOL)initFromNativeSocketHandle:(CFSocketNativeHandle)handle;

@end
