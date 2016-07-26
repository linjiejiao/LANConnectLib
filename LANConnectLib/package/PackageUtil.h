//
//  PackageUtil.h
//  LANConnectLib
//
//  Created by liangjiajian_mac on 16/7/13.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ByteBuffer.h"
#import "SeqIdGenerator.h"

typedef NS_ENUM (NSInteger, DataType){
    TYPE_BYTE,
    TYPE_SHORT,
    TYPE_INT,
    TYPE_FLOAT,
    TYPE_DOUBLE,
    TYPE_LONG64,
    TYPE_STRING,
    TYPE_RAW_DATA,
};

@protocol PackageProtocol <NSObject>
@required
- (int)size;
- (BOOL)packToBuffer:(ByteBuffer*)buffer;
- (BOOL)unPackFromBuffer:(ByteBuffer*)buffer;
@optional
- (int)uri;
- (int)seqId;
@end

@interface PackageUtil : NSObject

+ (void)packRawData:(NSData*)data buffer:(ByteBuffer*)buffer;
+ (NSData*)unPackRawData:(ByteBuffer*)buffer;

+ (void)packString:(NSString*)string buffer:(ByteBuffer*)buffer;
+ (NSString*)unPackString:(ByteBuffer*)buffer;

+ (void)packArray:(NSArray*)array type:(DataType)type buffer:(ByteBuffer*)buffer;
+ (NSArray*)unPackArrayType:(DataType)type buffer:(ByteBuffer*)buffer;

+ (void)packDictionary:(NSDictionary*)dic keyType:(DataType)keyType valueType:(DataType)valueType buffer:(ByteBuffer*)buffer;
+ (NSDictionary*)unPackDictionaryKeyType:(DataType)keyType valueType:(DataType)valueType  buffer:(ByteBuffer*)buffer;

+ (int)calculateRawDataSize:(NSData*)data;
+ (int)calculateStringSize:(NSString*)string;
+ (int)calculateArraySize:(NSArray*)array type:(DataType)type;
+ (int)calculateDictionarySize:(NSDictionary*)dic keyType:(DataType)keyType valueType:(DataType)valueType;

+ (NSData*)createDataFromProtocol:(id <PackageProtocol>)protocol;

@end
