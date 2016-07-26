//
//  ByteBuffer.h
//  LANConnectLib
//
//  Created by liangjiajian_mac on 16/7/21.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import <Foundation/Foundation.h>

const static int UNSET_MARK = -1;

@interface ByteBuffer : NSObject

@property (nonatomic, assign) int capacity;
@property (nonatomic, assign) int limmit;
@property (nonatomic, assign) int mark;
@property (nonatomic, assign) int position;

+ (ByteBuffer*)allocate:(int)capacity;
+ (ByteBuffer*)wrapData:(NSData*)data;
+ (ByteBuffer*)wrapData:(NSData*)data start:(int)start byteCount:(int)byteCount;

- (NSData*)data;
- (ByteBuffer*)getToDest:(NSMutableData*)dest;
- (ByteBuffer*)getToDest:(NSMutableData*)dest byteCount:(int)byteCount;
- (ByteBuffer*)getToDest:(NSMutableData*)dest offset:(int)offset byteCount:(int)byteCount;

- (Byte)get;
- (Byte)getAtIndex:(int)index;
- (double)getDouble;
- (double)getDoubleAtIndex:(int)index;
- (float)getFloat;
- (float)getFloatAtIndex:(int)index;
- (int)getInt;
- (int)getIntAtIndex:(int)index;
- (long long)getLong64;
- (long long)getLong64AtIndex:(int)index;
- (short)getShort;
- (short)getShortAtIndex:(int)index;

- (ByteBuffer*)putData:(NSData*)data;
- (ByteBuffer*)putData:(NSData*)data dataOffset:(int)offset byteCount:(int)count;
- (ByteBuffer*)putBuffer:(ByteBuffer*)buffer;

- (ByteBuffer*)putByte:(Byte)b;
- (ByteBuffer*)putByte:(Byte)b atIndex:(int)index;
- (ByteBuffer*)putDouble:(double)d;
- (ByteBuffer*)putDouble:(double)d atIndex:(int)index;
- (ByteBuffer*)putFloat:(float)f;
- (ByteBuffer*)putFloat:(float)f atIndex:(int)index;
- (ByteBuffer*)putInt:(int)i;
- (ByteBuffer*)putInt:(int)i atIndex:(int)index;
- (ByteBuffer*)putLong64:(long long)l;
- (ByteBuffer*)putLong64:(long long)l atIndex:(int)index;
- (ByteBuffer*)putShort:(short)s;
- (ByteBuffer*)putShort:(short)s atIndex:(int)index;

- (void)checkSize:(int)size;
- (void)checkIndex:(int)index sizeOfType:(int)size;
- (ByteBuffer*)clear;
- (BOOL)hasRemaining;
- (int)remaining;
- (ByteBuffer*)reset;
- (ByteBuffer*)rewind;

@end
