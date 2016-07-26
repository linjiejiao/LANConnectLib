//
//  TCPSection.m
//  LANConnectLib
//
//  Created by liangjiajian_mac on 16/7/22.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import "TCPSection.h"

@interface TCPSection() 

@end

@implementation TCPSection

/// need to orride!!!!!!
- (BOOL)initStreams{
    return NO;
}

- (BOOL)open {
    if(![self initStreams]){
        NSLog(@"initStreams failed!!!");
        return NO;
    }
    [self.inputStream setDelegate:self];
    [self.outputStream setDelegate:self];
    [self.inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.inputStream open];
    [self.outputStream open];
    _isConnected = YES;
    if([Config sharedInstance].debug){
        NSLog(@"open");
    }
    return YES;
}

- (void)close {
    _isConnected = NO;
    _canWrite = NO;
    _canRead = NO;
    _remoteIp = nil;
    _remotePort = 0;
    [self.inputStream close];
    [self.outputStream close];
    [self.inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    self.inputStream = nil;
    self.outputStream = nil;
    if([Config sharedInstance].debug){
        NSLog(@"close");
    }
}

- (int)sendData:(NSData*)data {
    if( !self.isConnected || !self.outputStream || !self.canWrite){
        NSLog(@"Can not send data! %d %d %d", self.isConnected, !self.outputStream, self.canWrite);
        return -1;
    }
    return [self.outputStream write:[data bytes] maxLength:data.length];
}

- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)streamEvent {
    if([Config sharedInstance].debug){
        NSLog(@"stream event %u", streamEvent);
    }
    if(stream == self.inputStream){
        [self handleInputStreamEvent:streamEvent];
    }else if(stream == self.outputStream){
        [self handleOutputStreamEvent:streamEvent];
    }else{
        NSLog(@"stream handleEvent stream=%@", stream);
    }
}

- (void)handleInputStreamEvent:(NSStreamEvent)streamEvent {
    switch (streamEvent) {
        case NSStreamEventOpenCompleted: {
            if(self.delegate && [self.delegate respondsToSelector:@selector(onStreamOpened:)]){
                [self.delegate onStreamOpened:self.inputStream];
            }
            _canRead = YES;
        }
            break;
        case NSStreamEventHasBytesAvailable: {
            uint8_t buffer[TCP_BUFFER_SIZE];
            int len;
            NSMutableData *data = [NSMutableData new];
            while ([self.inputStream hasBytesAvailable]) {
                len = [self.inputStream read:buffer maxLength:TCP_BUFFER_SIZE];
                if (len > 0) {
                    [data appendBytes:buffer length:len];
                }
            }
            if(self.delegate){
                [self.delegate onReceiveData:data];
            }
        }
            break;
        case NSStreamEventErrorOccurred: {
            if(self.delegate && [self.delegate respondsToSelector:@selector(onErrorOccured:)]){
                [self.delegate onErrorOccured:self.inputStream];
            }
            NSLog(@"InputStream Error Occurred!");
        }
        case NSStreamEventEndEncountered: {
            _canRead = NO;
            if(self.delegate && [self.delegate respondsToSelector:@selector(onStreamClosed:)]){
                [self.delegate onStreamClosed:self.inputStream];
            }
            [self.inputStream close];
            [self.inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            break;
        }
        default:
            NSLog(@"Unknown event for InputStream! %u", streamEvent);
    }
}

- (void)handleOutputStreamEvent:(NSStreamEvent)streamEvent {
    switch (streamEvent) {
        case NSStreamEventOpenCompleted: {
            if(self.delegate && [self.delegate respondsToSelector:@selector(onStreamOpened:)]){
                [self.delegate onStreamOpened:self.outputStream];
            }
            _canWrite = YES;
        }
            break;
        case NSStreamEventHasSpaceAvailable: {
            if([Config sharedInstance].debug){
                NSLog(@"NSStreamEventHasSpaceAvailable");
            }
            break;
        }
        case NSStreamEventErrorOccurred: {
            if(self.delegate && [self.delegate respondsToSelector:@selector(onErrorOccured:)]){
                [self.delegate onErrorOccured:self.outputStream];
            }
            NSLog(@"OutputStream Error Occurred!");
        }
        case NSStreamEventEndEncountered: {
            _canWrite = NO;
            if(self.delegate && [self.delegate respondsToSelector:@selector(onStreamClosed:)]){
                [self.delegate onStreamClosed:self.outputStream];
            }
            [self.outputStream close];
            [self.outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            break;
        }
        default:
            NSLog(@"Unknown event for OutputStream! %u", streamEvent);
    }
}

@end
