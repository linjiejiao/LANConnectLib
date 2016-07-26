//
//  PackageUtil.m
//  LANConnectLib
//
//  Created by liangjiajian_mac on 16/7/13.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import "PackageUtil.h"

@implementation PackageUtil

#pragma mark - raw data
+ (void)packRawData:(NSData*)data buffer:(ByteBuffer*)buffer {
    if(!data){
        [buffer putShort:0];
        return;
    }
    [buffer putShort:data.length];
    [buffer putData:data];
}

+ (NSData*)unPackRawData:(ByteBuffer*)buffer {
    int length = [buffer getShort];
    NSMutableData *data = [[NSMutableData alloc]initWithCapacity:length];
    [buffer getToDest:data byteCount:length];
    return data;
}

#pragma mark - string
+ (void)packString:(NSString*)string buffer:(ByteBuffer*)buffer {
    if(!string){
        [buffer putShort:0];
        return;
    }
    NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
    [PackageUtil packRawData:stringData buffer:buffer];
}

+ (NSString*)unPackString:(ByteBuffer*)buffer {
    NSMutableData *stringData = (NSMutableData*)[PackageUtil unPackRawData:buffer];
    return [[NSString alloc]initWithData:stringData encoding:NSUTF8StringEncoding];
}

#pragma mark - array
+ (void)packArray:(NSArray*)array type:(DataType)type buffer:(ByteBuffer*)buffer {
    if(!array){
        [buffer putShort:0];
        return;
    }else{
        [buffer putShort:array.count];
    }
    for(NSObject *obj in array){
        [PackageUtil packData:obj type:type buffer:buffer];
    }
}

+ (NSArray*)unPackArrayType:(DataType)type buffer:(ByteBuffer*)buffer {
    short count = [buffer getShort];
    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:count];
    for(int i=0; i<count; i++){
        [array addObject:[PackageUtil unPackDataByType:type buffer:buffer]];
    }
    return array;
}

#pragma mark - dictionary
+ (void)packDictionary:(NSDictionary*)dic keyType:(DataType)keyType valueType:(DataType)valueType buffer:(ByteBuffer*)buffer {
    if(!dic){
        [buffer putShort:0];
        return;
    }
    [buffer putShort:dic.count];
    NSArray *keys = [dic allKeys];
    for(NSObject *key in keys){
        NSObject *value = [dic objectForKey:key];
        [PackageUtil packData:key type:keyType buffer:buffer];
        [PackageUtil packData:value type:valueType buffer:buffer];
    }
}

+ (NSDictionary*)unPackDictionaryKeyType:(DataType)keyType valueType:(DataType)valueType  buffer:(ByteBuffer*)buffer {
    short count = [buffer getShort];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:count];
    for(int i=0; i<count; i++){
        NSObject *key = [PackageUtil unPackDataByType:keyType buffer:buffer];
        NSObject *value = [PackageUtil unPackDataByType:valueType buffer:buffer];
        [dic setObject:value forKey:key];
    }
    return dic;
}

#pragma mark - calculate size
+ (int)calculateRawDataSize:(NSData*)data {
    int count = 2;
    if(data){
        count += data.length;
    }
    return count;
}

+ (int)calculateStringSize:(NSString*)string {
    int count = 2;
    if(string){
        return [PackageUtil calculateRawDataSize:[string dataUsingEncoding:NSUTF8StringEncoding]];
    }
    return count;
}

+ (int)calculateArraySize:(NSArray*)array type:(DataType)type{
    int count = 2;
    if(array){
        for(NSObject *obj in array){
            count += [PackageUtil calculateDataSize:obj type:type];
        }
    }
    return count;
}

+ (int)calculateDictionarySize:(NSDictionary*)dic keyType:(DataType)keyType valueType:(DataType)valueType {
    int count = 2;
    NSArray *keys = [dic allKeys];
    for(NSObject *key in keys){
        NSObject *value = [dic objectForKey:key];
        count += [PackageUtil calculateDataSize:key type:keyType];
        count += [PackageUtil calculateDataSize:value type:valueType];
    }
    return count;
}

#pragma mark - protocol
+ (NSData*)createDataFromProtocol:(id<PackageProtocol>)protocol {
    int size = 4/*all size*/ + 4/*uri*/ + [protocol size];
    ByteBuffer *buffer = [ByteBuffer allocate:size];
    [buffer putInt:size];
    [buffer putInt:[protocol uri]];
    [protocol packToBuffer:buffer];
    return buffer.data;
}

#pragma mark - common
+ (NSObject*)unPackDataByType:(DataType)type buffer:(ByteBuffer*)buffer {
    switch (type){
        case TYPE_BYTE:{
            Byte b = [buffer get];
            return @(b);
        }
        case TYPE_SHORT:{
            short b = [buffer getShort];
            return @(b);
        }
        case TYPE_INT:{
            Byte b = [buffer getInt];
            return @(b);
        }
        case TYPE_FLOAT:{
            Byte b = [buffer getFloat];
            return @(b);
        }
        case TYPE_DOUBLE:{
            Byte b = [buffer getDouble];
            return @(b);
        }
        case TYPE_LONG64:{
            Byte b = [buffer getLong64];
            return @(b);
        }
        case TYPE_STRING:{
            NSString *string = [PackageUtil unPackString:buffer];
            return string;
        }
        case TYPE_RAW_DATA:{
            NSData *data = [PackageUtil unPackRawData:buffer];
            return data;
        }
        default:
            NSLog(@"Unknown type:%d", type);
            @throw [[NSException alloc]initWithName:NSInvalidArgumentException reason:@"Unpack with unknown type!" userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@(type), @"type", nil]];
    }
}

+ (void)packData:(NSObject*)obj type:(DataType)type buffer:(ByteBuffer*)buffer {
    switch (type){
        case TYPE_BYTE:{
            NSNumber *number = (NSNumber*)obj;
            [buffer putByte:[number charValue]];
        }
            break;
        case TYPE_SHORT:{
            NSNumber *number = (NSNumber*)obj;
            [buffer putShort:[number shortValue]];
        }
            break;
        case TYPE_INT:{
            NSNumber *number = (NSNumber*)obj;
            [buffer putInt:[number intValue]];
        }
            break;
        case TYPE_FLOAT:{
            NSNumber *number = (NSNumber*)obj;
            [buffer putFloat:[number floatValue]];
        }
            break;
        case TYPE_DOUBLE:{
            NSNumber *number = (NSNumber*)obj;
            [buffer putDouble:[number doubleValue]];
        }
            break;
        case TYPE_LONG64:{
            NSNumber *number = (NSNumber*)obj;
            [buffer putLong64:[number longLongValue]];
        }
            break;
        case TYPE_STRING:{
            NSString *string = (NSString*)obj;
            [PackageUtil packString:string buffer:buffer];
        }
            break;
        case TYPE_RAW_DATA:{
            NSData *data = (NSData*)obj;
            [PackageUtil packRawData:data buffer:buffer];
        }
            break;
        default:
            NSLog(@"Unknown type:%d", type);
            @throw [[NSException alloc]initWithName:NSInvalidArgumentException reason:@"Pack with unknown type!" userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@(type), @"type", nil]];
    }
}

+ (int)calculateDataSize:(NSObject*)obj type:(DataType)type{
    switch (type){
        case TYPE_BYTE:
            return 1;
        case TYPE_SHORT:
            return 2;
        case TYPE_INT:
            return 4;
        case TYPE_FLOAT:
            return 4;
        case TYPE_DOUBLE:
            return 8;
        case TYPE_LONG64:
            return 8;
        case TYPE_STRING:{
            NSString *string = (NSString*)obj;
            return [PackageUtil calculateStringSize:string];
        }
            break;
        case TYPE_RAW_DATA:{
            NSData *data = (NSData*)obj;
            return [PackageUtil calculateRawDataSize:data];
        }
            break;
        default:
            NSLog(@"Unknown type:%d", type);
            @throw [[NSException alloc]initWithName:NSInvalidArgumentException reason:@"CalculateDataSize with unknown type!" userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@(type), @"type", nil]];
    }
}
@end
