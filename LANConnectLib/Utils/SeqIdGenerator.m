//
//  SeqIdGenerator.m
//  LANConnectLib
//
//  Created by liangjiajian_mac on 16/7/25.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import "SeqIdGenerator.h"

@implementation SeqIdGenerator {
    int seqId;
}
static SeqIdGenerator *_instance;

+ (SeqIdGenerator*) sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [SeqIdGenerator new];
    });
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if(self){
        seqId = (int)[[NSDate date] timeIntervalSince1970];
    }
    return self;
}

- (int)getNextSeqId {
    @synchronized (self) {
        return seqId ++;
    }
}

@end
