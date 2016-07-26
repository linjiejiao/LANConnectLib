//
//  SnifferManager.m
//  LANConnectLib
//
//  Created by liangjiajian_mac on 16/7/22.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import "SnifferManager.h"
#import "UDPReceiver.h"
#import "ByteBuffer.h"
#import "SniffRes.h"
#import "SniffReq.h"
#import "UDPReceiver.h"
#import "UDPSender.h"
#import "LocalIPUtils.h"
#import "UDPServerManager.h"
#import "TCPServerManager.h"
#import "Config.h"

#define SNIFF_TIMEOUT   5

static const SNIFF_SEND_PORT = SNIFF_UDP_PORT + 1;
static const SNIFF_LISTEN_PORT = SNIFF_UDP_PORT;

@interface SnifferManager() <UDPDataDelegate>
@property (nonatomic, strong) NSMutableArray *sniffCallbacks;
@property (nonatomic, strong) NSMutableArray *sniffResults;
@property (nonatomic, strong) UDPReceiver *receiver;
@property (nonatomic, strong) UDPSender *sender;

@end

@implementation SnifferManager
static SnifferManager* _instance;

+ (SnifferManager*)shareInstance {
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        _instance = [SnifferManager new];
        [_instance initManager];
    });
    return _instance;
}

- (void)initManager {
    self.respondSniffReq = YES;
    self.sniffCallbacks = [NSMutableArray new];
    self.sniffResults = [NSMutableArray new];
    self.sender = [[UDPSender alloc]initWithLocalPort:SNIFF_SEND_PORT];
    self.receiver = [[UDPReceiver alloc]initWithLocalPort:SNIFF_LISTEN_PORT];
    self.receiver.delegate = self;
}

- (void)onReceiveData:(NSData *)data fromIP:(NSString *)ip port:(short)port error:(NSError *)error {
    ByteBuffer *buffer = [ByteBuffer wrapData:data];
    // TODO:分包情况处理
    int size = [buffer getInt];
    int uri = [buffer getInt];
    NSLog(@"onReceiveData uri=%d", uri);
    switch (uri){
        case SniffResUri: {
            SniffRes *res = [SniffRes new];
            [res unPackFromBuffer:buffer];
            [self checkTerminal:res.terminal fromIP:ip port:port];
            [self addTerminal:res.terminal];
        }
            break;
        case SniffReqUri: {
            SniffReq *req = [SniffReq new];
            [req unPackFromBuffer:buffer];
            [self checkTerminal:req.terminal fromIP:ip port:port];
            [self addTerminal:req.terminal];
            if(self.respondSniffReq){
                [self sendSniffRes:req.seqId toIp:ip];
            } else {
                NSLog(@"receiveing %@ while respondSniffReq is NO!", req);
            }
        }
            break;
    }
}

- (void)checkTerminal:(Terminal*)terminal fromIP:(NSString *)ip port:(short)port {
    if(!terminal.ipAddress || terminal.ipAddress.length < 7) {
        terminal.ipAddress = ip;
    }
    if(terminal.udpServerPort == 0){
        terminal.udpServerPort = port;
    }
}

- (void)startSniffing:(SniffResultCallBack)callback {
    @synchronized (self.sniffCallbacks) {
        [self.sniffCallbacks addObject:callback];
    }
    [self broadcastSniffReq];
    [self performSelector:@selector(endSniffing) withObject:nil afterDelay:SNIFF_TIMEOUT];
}

- (void)endSniffing {
    @synchronized (self.sniffCallbacks) {
        for(SniffResultCallBack callback in self.sniffCallbacks){
            callback(self.sniffResults);
        }
        [self.sniffCallbacks removeAllObjects];
    }
}

- (int)broadcastSniffReq {
    SniffReq *req = [SniffReq new];
    req.seqId = [[SeqIdGenerator sharedInstance] getNextSeqId];
    req.terminal = [self getMyselfTerminal];
    NSLog(@"broadcastSniffReq req=%@", req);
    NSData *data = [PackageUtil createDataFromProtocol:req];
    [self.sender sendData:data toIp:[LocalIPUtils getBroadcastAdress] port:SNIFF_LISTEN_PORT];
    return req.seqId;
}

- (void)sendSniffRes:(int)seqId toIp:(NSString *)ip {
    SniffRes *res = [SniffRes new];
    res.seqId = seqId;
    res.terminal = [self getMyselfTerminal];
    NSLog(@"sendSniffRes res=%@", res);
    NSData *data = [PackageUtil createDataFromProtocol:res];
    [self.sender sendData:data toIp:ip port:SNIFF_LISTEN_PORT];
}

- (void)cancelSniffing {
    self.receiver.delegate = nil;
    [self.receiver close];
    self.receiver = nil;
}

- (Terminal*)getMyselfTerminal {
    Terminal *terminal = [Terminal new];
    terminal.ipAddress = [LocalIPUtils getIPAddress];
    terminal.tcpServerPort = [TCPServerManager serverPort];
    terminal.udpServerPort = [UDPServerManager serverPort];
    NSString *name = [Config sharedInstance].name;
    if(!name || name.length <= 0) {
        name = terminal.ipAddress;
    }
    terminal.name = name;
    return terminal;
}

- (void)addTerminal:(Terminal*)terminal {
    @synchronized (self.sniffResults) {
        for (Terminal* t in self.sniffResults) {
            if([t isEqual:terminal]) {
                return;
            }
        }
        [self.sniffResults addObject:terminal];
    }
}

@end
