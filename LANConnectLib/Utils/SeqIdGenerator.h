//
//  SeqIdGenerator.h
//  LANConnectLib
//
//  Created by liangjiajian_mac on 16/7/25.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SeqIdGenerator : NSObject
+ (SeqIdGenerator*) sharedInstance;
- (int)getNextSeqId;

@end
