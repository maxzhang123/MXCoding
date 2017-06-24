//
//  NSObject+MXCoding.m
//  MXAutoCoding
//
//  Created by Max on 2017/4/27.
//  Copyright © 2017年 maxzhang. All rights reserved.
//

#import "NSObject+MXCoding.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

static NSString *intType     = @"i"; // int_32t(枚举int型)
static NSString *longTpye    = @"l"; //long类型
static NSString *longlongType= @"q"; // longlong类型
static NSString *BoolType    = @"B"; //bool类型
static NSString *floatType   = @"f"; // float
static NSString *doubleType  = @"d"; // double
static NSString *boolType    = @"c";
static NSString *stringType  = @"NSString"; // NSString 类型
static NSString *numberType  = @"NSNumber"; // NSNumber 类型
static NSString *arrayType   = @"arrayType";//array类型
static NSString *imageType   = @"UIImage"; // UIImage 类型

@implementation NSObject (MXCoding)


//归档
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    
    unsigned int count; // 属性个数
    Ivar *varArray = class_copyIvarList([self class], &count);
    
    for (int i = 0; i < count; i++)
    {
        Ivar var = varArray[i];
        const char *cName = ivar_getName(var); // 属性名c字符串
        NSString *proName = [[NSString stringWithUTF8String:cName] substringFromIndex:1]; //OC字符串,并且去掉下划线 _
        const char *cType = ivar_getTypeEncoding(var); // 获取变量类型，c字符串
        
        id value = [self valueForKey:proName];
        NSString *proType = [NSString stringWithUTF8String:cType]; // oc 字符串
        
        if ([proType containsString:@"NSString"]) {
            proType = stringType;
        }
        if ([proType containsString:@"NSNumber"]) {
            proType = numberType;
        }
        if ([proType containsString:@"NSArray"]) {
            proType = arrayType;
        }
        if ([proType containsString:@"UIImage"]) {
            proType = imageType;
        }
        
        // (5). 根据类型进行编码
        if ([proType isEqualToString:intType] || [proType isEqualToString:boolType] || [proType isEqualToString:BoolType]) {
            [aCoder encodeInt32:[value intValue] forKey:proName];
        }
        else if ([proType isEqualToString:longTpye]) {
            [aCoder encodeInt64:[value longValue] forKey:proName];
        }
        else if ([proType isEqualToString:floatType]) {
            [aCoder encodeFloat:[value floatValue] forKey:proName];
        }
        else if ([proType isEqualToString:longlongType] || [proType isEqualToString:doubleType]) {
            [aCoder encodeDouble:[value doubleValue] forKey:proName];
        }
        else if ([proType isEqualToString:stringType]) { // string 类型
            [aCoder encodeObject:value forKey:proName];
        }
        else if ([proType isEqualToString:numberType]) {
            [aCoder encodeObject:value forKey:proName];
        }
        else if ([proType isEqualToString:arrayType]) {
            [aCoder encodeObject:value forKey:proName];
        }
        else if ([proType isEqualToString:imageType]) { // image 类型
            [aCoder encodeDataObject:UIImagePNGRepresentation(value)];
        }
    }
    free(varArray);
}


//反归档，是一个解码的过程。
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self) {
        
        unsigned int count;
        Ivar *varArray = class_copyIvarList([self class], &count);
        
        for (int i = 0; i < count; i++) {
            Ivar var = varArray[i];
            const char *cName = ivar_getName(var); // 属性名c字符串
            NSString *proName = [[NSString stringWithUTF8String:cName] substringFromIndex:1]; //OC字符串,并且去掉下划线 _
            const char *cType = ivar_getTypeEncoding(var); // 获取变量类型，c字符串
            NSString *proType = [NSString stringWithUTF8String:cType]; // oc 字符串
            
            if ([proType containsString:@"NSString"]) {
                proType = stringType;
            }
            if ([proType containsString:@"NSNumber"]) {
                proType = numberType;
            }
            if ([proType containsString:@"NSArray"]) {
                proType = arrayType;
            }
            if ([proType containsString:@"UIImage"]) {
                proType = imageType;
            }
            
            if ([proType isEqualToString:intType] || [proType isEqualToString:boolType] || [proType isEqualToString:BoolType]) {
                int32_t number = [aDecoder decodeInt32ForKey:proName];
                [self setValue:@(number) forKey:proName];
            }
            else if ([proType isEqualToString:longTpye]) {
                int64_t number = [aDecoder decodeInt64ForKey:proName];
                [self setValue:@(number) forKey:proName];
            }
            else if ([proType isEqualToString:floatType]) {
                float number = [aDecoder decodeFloatForKey:proName];
                [self setValue:@(number) forKey:proName];
            }
            else if ([proType isEqualToString:longlongType] || [proType isEqualToString:doubleType]) {
                double number = [aDecoder decodeFloatForKey:proName];
                [self setValue:@(number) forKey:proName];
            }
            else if ([proType isEqualToString:stringType]) { // string 类型
                NSString *string = [aDecoder decodeObjectForKey:proName];
                [self setValue:string forKey:proName];
            }
            else if ([proType isEqualToString:numberType]) {
                NSString *number = [aDecoder decodeObjectForKey:proName];
                [self setValue:number forKey:proName];
            }
            else if ([proType isEqualToString:arrayType]) {
                NSArray *array = [aDecoder decodeObjectForKey:proName];
                [self setValue:array forKey:proName];
            }
            else if ([proType isEqualToString:imageType]) { // image 类型
                UIImage *image = [UIImage imageWithData:[aDecoder decodeDataObject]];
                [self setValue:image forKey:proName];
            }
        }
    }
    return self;
}


//存储路径
- (NSString *)filePathWithUniqueFlagString:(NSString *)uniqueFlag
{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *detailPath = [NSString stringWithFormat:@"%@_%@",uniqueFlag,[NSString stringWithUTF8String:object_getClassName(self)]];
    NSString *path = [docPath stringByAppendingPathComponent:detailPath];
    return path;
}


//保存对象数据到本地
- (void)saveDataToLocalWithUniqueFlagKey:(NSString *)uniqueFlagKey
{
    [NSKeyedArchiver archiveRootObject:self toFile:[self filePathWithUniqueFlagString:uniqueFlagKey]];
}


//清空本地存储的对象数据
- (id)getDataFromLocalWithUniqueFlagKey:(NSString *)uniqueFlagKey
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self filePathWithUniqueFlagString:uniqueFlagKey]];
}


//从本地获取对象数据
- (BOOL)removeDataFromLocalWithUniqueFlagKey:(NSString *)uniqueFlagKey
{
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:[self filePathWithUniqueFlagString:uniqueFlagKey] error:&error];
    if (!error) {
        return YES;
    }
    else {
        return NO;
    }
}






@end
