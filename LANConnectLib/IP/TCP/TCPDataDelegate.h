//
//  TCPDataDelegate.h
//  LANConnectLib
//
//  Created by liangjiajian_mac on 16/7/21.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//


#import <Foundation/Foundation.h>

@protocol TCPDataDelegate <NSObject>
@required
- (void)onReceiveData:(NSData*)data;
@optional
- (void)onStreamOpened:(NSStream*)stream;
- (void)onErrorOccured:(NSStream*)stream;
- (void)onStreamClosed:(NSStream*)stream;

@end
