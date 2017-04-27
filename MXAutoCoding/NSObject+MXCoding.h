//
//  NSObject+MXCoding.h
//  MXAutoCoding
//
//  Created by Max on 2017/4/27.
//  Copyright © 2017年 maxzhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (MXCoding)<NSCoding>


/**
 保存对象数据到本地
 
 @param uniqueFlagKey 保存需要拼接的唯一标识，如果不传 则只会以类名作为文件名保存
 */
- (void)saveDataToLocalWithUniqueFlagKey:(NSString *)uniqueFlagKey;



/**
 清空本地存储的对象数据
 
 @param uniqueFlagKey 保存对象时存入的唯一标识，如果保存时没传则此处也不需要传入
 @return 是否清空成功
 */
- (BOOL)removeDataFromLocalWithUniqueFlagKey:(NSString *)uniqueFlagKey;



/**
 从本地获取对象数据
 
 @param uniqueFlagKey 保存对象时存入的唯一标识，如果保存时没传则此处也不需要传入
 @return 保存的对象
 */
- (id)getDataFromLocalWithUniqueFlagKey:(NSString *)uniqueFlagKey;

@end
