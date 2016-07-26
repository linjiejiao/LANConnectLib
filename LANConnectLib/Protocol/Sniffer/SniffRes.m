//
//  SniffRes.m
//  LANConnectLib
//
//  Created by liangjiajian_mac on 16/7/23.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import "SniffRes.h"

@implementation SniffRes
- (Terminal*)terminal {
    if(!_terminal){
        _terminal = [Terminal new];
    }
    return _terminal;
}

- (int)size {
    return 4 + [self.terminal size];
}

- (BOOL)packToBuffer:(ByteBuffer*)buffer {
    [buffer putInt:self.seqId];
    [self.terminal packToBuffer:buffer];
    return YES;
}

- (BOOL)unPackFromBuffer:(ByteBuffer*)buffer {
    self.seqId = [buffer getInt];
    [self.terminal unPackFromBuffer:buffer];
    return YES;
}

- (int)uri {
    return SniffResUri;
}

- (int)seqId {
    return _seqId;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"SniffRes[seqId=%u, terminal=%@]", self.seqId, self.terminal];
}

@end
