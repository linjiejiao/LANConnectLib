//
//  ByteBuffer.m
//  LANConnectLib
//
//  Created by liangjiajian_mac on 16/7/21.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import "ByteBuffer.h"

@interface ByteBuffer()
@property (nonatomic, strong) NSMutableData* data;

@end

@implementation ByteBuffer

+ (ByteBuffer*)allocate:(int)capacity {
    if(capacity < 0){
        @throw [NSException exceptionWithName:NSRangeException reason:@"capacity < 0" userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@(capacity), @"capacity", nil]];
    }
    ByteBuffer *buffer = [ByteBuffer new];
    buffer.data = [[NSMutableData alloc] initWithCapacity:capacity];
    buffer.limmit = buffer.capacity = capacity;
    return buffer;
}

+ (ByteBuffer*)wrapData:(NSData*)data {
    ByteBuffer *buffer = [ByteBuffer new];
    buffer.data = [[NSMutableData alloc] initWithData:data];
    buffer.limmit = buffer.capacity = data.length;
    return buffer;
}

+ (ByteBuffer*)wrapData:(NSData*)data start:(int)start byteCount:(int)byteCount {
    ByteBuffer *buffer = [ByteBuffer new];
    NSRange rang = NSMakeRange(start, byteCount);
    buffer.data = [[NSMutableData alloc] initWithData:[data subdataWithRange:rang]];
    buffer.limmit = buffer.capacity = byteCount;
    return buffer;
}

- (instancetype)init {
    self = [super init];
    if(self){
        self.data = [[NSMutableData alloc] initWithCapacity:0];
        _capacity = 0;
        _position = 0;
        _limmit = 0;
        _mark = UNSET_MARK;
    }
    return self;
}

- (NSData*)data {
    return _data;
}

- (ByteBuffer*)getToDest:(NSMutableData*)dest {
    [dest appendData:self.data];
    return self;
}

- (ByteBuffer*)getToDest:(NSMutableData*)dest byteCount:(int)byteCount {
    [self getToDest:dest offset:self.position byteCount:byteCount];
    self.position += byteCount;
    return self;
}

- (ByteBuffer*)getToDest:(NSMutableData*)dest offset:(int)offset byteCount:(int)byteCount {
    [self checkIndex:offset sizeOfType:byteCount];
    NSRange rang = NSMakeRange(offset, byteCount);
    [dest appendData:[self.data subdataWithRange:rang]];
    return self;
}

- (Byte)get {
    Byte b;
    [self checkSize:sizeof(b)];
    NSRange range = NSMakeRange(self.position, sizeof(b));
    [_data getBytes:&b range:range];
    self.position += sizeof(b);
    return b;
}

- (Byte)getAtIndex:(int)index {
    Byte b;
    [self checkIndex:index sizeOfType:sizeof(b)];
    NSRange range = NSMakeRange(index, sizeof(b));
    [_data getBytes:&b range:range];
    return b;
}

- (double)getDouble {
    double b;
    [self checkSize:sizeof(b)];
    NSRange range = NSMakeRange(self.position, sizeof(b));
    [_data getBytes:&b range:range];
    self.position += sizeof(b);
    return b;
}

- (double)getDoubleAtIndex:(int)index {
    double b;
    [self checkIndex:index sizeOfType:sizeof(b)];
    NSRange range = NSMakeRange(index, sizeof(b));
    [_data getBytes:&b range:range];
    return b;
}

- (float)getFloat{
    float b;
    [self checkSize:sizeof(b)];
    NSRange range = NSMakeRange(self.position, sizeof(b));
    [_data getBytes:&b range:range];
    self.position += sizeof(b);
    return b;
}

- (float)getFloatAtIndex:(int)index{
    float b;
    [self checkIndex:index sizeOfType:sizeof(b)];
    NSRange range = NSMakeRange(index, sizeof(b));
    [_data getBytes:&b range:range];
    return b;
}

- (int)getInt{
    int b;
    [self checkSize:sizeof(b)];
    NSRange range = NSMakeRange(self.position, sizeof(b));
    [_data getBytes:&b range:range];
    self.position += sizeof(b);
    return b;
}

- (int)getIntAtIndex:(int)index{
    int b;
    [self checkIndex:index sizeOfType:sizeof(b)];
    NSRange range = NSMakeRange(index, sizeof(b));
    [_data getBytes:&b range:range];
    return b;
}

- (long long)getLong64 {
    long long b;
    [self checkSize:sizeof(b)];
    NSRange range = NSMakeRange(self.position, sizeof(b));
    [_data getBytes:&b range:range];
    self.position += sizeof(b);
    return b;
}

- (long long)getLong64AtIndex:(int)index {
    long long b;
    [self checkIndex:index sizeOfType:sizeof(b)];
    NSRange range = NSMakeRange(index, sizeof(b));
    [_data getBytes:&b range:range];
    return b;
}

- (short)getShort {
    short b;
    [self checkSize:sizeof(b)];
    NSRange range = NSMakeRange(self.position, sizeof(b));
    [_data getBytes:&b range:range];
    self.position += sizeof(b);
    return b;
}

- (short)getShortAtIndex:(int)index {
    short b;
    [self checkIndex:index sizeOfType:sizeof(b)];
    NSRange range = NSMakeRange(index, sizeof(b));
    [_data getBytes:&b range:range];
    return b;
}

#pragma mark putter

- (ByteBuffer*)putData:(NSData*)data {
    if (!data) {
        @throw [NSException exceptionWithName:@"invalid arg" reason:@"invalid arg" userInfo:nil];
    }
    [self checkSize:data.length];
    NSRange range = NSMakeRange(self.position, data.length);
    [_data replaceBytesInRange:range withBytes:[data bytes]];
    self.position += data.length;
    return self;
}
- (ByteBuffer*)putData:(NSData*)data dataOffset:(int)offset byteCount:(int)count {
    if (!data) {
        @throw [NSException exceptionWithName:@"invalid arg" reason:@"invalid arg" userInfo:nil];
    }
    [self checkIndex:offset sizeOfType:count];
    NSRange range = NSMakeRange(offset, count);
    data = [data subdataWithRange:range];
    range = NSMakeRange(self.position, count);
    [_data replaceBytesInRange:range withBytes:[data bytes]];
    return self;
}

- (ByteBuffer*)putBuffer:(ByteBuffer*)buffer {
    if (!buffer) {
        @throw [NSException exceptionWithName:@"invalid arg" reason:@"invalid arg" userInfo:nil];
    }
    [self checkSize:buffer.data.length];
    [self putData:buffer.data];
    return self;
}

- (ByteBuffer*)putByte:(Byte)b {
    [self checkSize:sizeof(b)];
    NSRange range = NSMakeRange(self.position, sizeof(b));
    [_data replaceBytesInRange:range withBytes:&b];
    self.position += sizeof(b);
    return self;
}

- (ByteBuffer*)putByte:(Byte)b atIndex:(int)index {
    [self checkIndex:index sizeOfType:sizeof(b)];
    NSRange range = NSMakeRange(index, sizeof(b));
    [_data replaceBytesInRange:range withBytes:&b];
    return self;
}

- (ByteBuffer*)putDouble:(double)d {
    [self checkSize:sizeof(d)];
    NSRange range = NSMakeRange(self.position, sizeof(d));
    [_data replaceBytesInRange:range withBytes:&d];
    self.position += sizeof(d);
    return self;
}

- (ByteBuffer*)putDouble:(double)d atIndex:(int)index {
    [self checkIndex:index sizeOfType:sizeof(d)];
    NSRange range = NSMakeRange(index, sizeof(d));
    [_data replaceBytesInRange:range withBytes:&d];
    return self;
}

- (ByteBuffer*)putFloat:(float)f {
    [self checkSize:sizeof(f)];
    NSRange range = NSMakeRange(self.position, sizeof(f));
    [_data replaceBytesInRange:range withBytes:&f];
    self.position += sizeof(f);
    return self;
}

- (ByteBuffer*)putFloat:(float)f atIndex:(int)index {
    [self checkIndex:index sizeOfType:sizeof(f)];
    NSRange range = NSMakeRange(index, sizeof(f));
    [_data replaceBytesInRange:range withBytes:&f];
    return self;
}

- (ByteBuffer*)putInt:(int)i {
    [self checkSize:sizeof(i)];
    NSRange range = NSMakeRange(self.position, sizeof(i));
    [_data replaceBytesInRange:range withBytes:&i];
    self.position += sizeof(i);
    return self;
}

- (ByteBuffer*)putInt:(int)i atIndex:(int)index {
    [self checkIndex:index sizeOfType:sizeof(i)];
    NSRange range = NSMakeRange(index, sizeof(i));
    [_data replaceBytesInRange:range withBytes:&i];
    return self;
}

- (ByteBuffer*)putLong64:(long long)l {
    [self checkSize:sizeof(l)];
    NSRange range = NSMakeRange(self.position, sizeof(l));
    [_data replaceBytesInRange:range withBytes:&l];
    self.position += sizeof(l);
    return self;
}

- (ByteBuffer*)putLong64:(long long)l atIndex:(int)index{
    [self checkIndex:index sizeOfType:sizeof(l)];
    NSRange range = NSMakeRange(index, sizeof(l));
    [_data replaceBytesInRange:range withBytes:&l];
    return self;
}

- (ByteBuffer*)putShort:(short)s{
    [self checkSize:sizeof(s)];
    NSRange range = NSMakeRange(self.position, sizeof(s));
    [_data replaceBytesInRange:range withBytes:&s];
    self.position += sizeof(s);
    return self;
}

- (ByteBuffer*)putShort:(short)s atIndex:(int)index{
    [self checkIndex:index sizeOfType:sizeof(s)];
    NSRange range = NSMakeRange(index, sizeof(s));
    [_data replaceBytesInRange:range withBytes:&s];
    return self;
}

#pragma mark others

- (void)checkSize:(int)size{
    [self checkIndex:self.position sizeOfType:size];
}

- (void)checkIndex:(int)index sizeOfType:(int)size{
    if(index < 0 || index > _limmit - size){
        @throw [NSException exceptionWithName:NSRangeException reason:@"checkIndex out of index" userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@(index), @"index", @(size), @"size", @(_limmit), @"limmit", nil]];
    }
}

- (ByteBuffer*)clear{
    _position = 0;
    _mark = UNSET_MARK;
    _limmit = _capacity;
    return self;
}

- (BOOL)hasRemaining{
    return _position < _limmit;
}

- (int)mark{
    _mark = _position;
    return _mark;
}

- (void)setLimmit:(int)newLimmit{
    if(newLimmit < 0 || newLimmit > _capacity){
        @throw [NSException exceptionWithName:NSRangeException reason:@"setlimmit out of index" userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@(newLimmit), @"newLimmit", @(_capacity), @"_capacity", nil]];
    }
    _limmit = newLimmit;
    if(_position > newLimmit){
        _position = newLimmit;
    }
    if(_mark != UNSET_MARK && _mark > newLimmit){
        _mark = UNSET_MARK;
    }
}

- (void)setPosition:(int)newPosition{
    if(newPosition < 0 || newPosition > _limmit){
        @throw [NSException exceptionWithName:NSRangeException reason:@"setPosition out of index" userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@(newPosition), @"newPosition", @(_limmit), @"_limmit", nil]];
    }
    _position = newPosition;
    if(_mark != UNSET_MARK && _mark > newPosition){
        _mark = UNSET_MARK;
    }
}

- (int)remaining{
    return _limmit - _position;
}

- (ByteBuffer*)reset{
    if(_mark == UNSET_MARK){
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"reset mark not set" userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@(_mark), @"_mark", nil]];
    }
    return self;
}

- (ByteBuffer*)rewind{
    _position = 0;
    _mark = UNSET_MARK;
    return self;
}
@end
