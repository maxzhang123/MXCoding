//
//  MXTestModel.h
//  MXAutoCoding
//
//  Created by Max on 2017/4/27.
//  Copyright © 2017年 maxzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+MXCoding.h"

@interface MXTestModel : NSObject<NSCoding>

@property (assign, nonatomic) int intVal;
@property (assign, nonatomic) NSInteger integerVal;
@property (assign, nonatomic) long longVal;
@property (assign, nonatomic) int64_t longlongVal;
@property (assign, nonatomic) float floatVal;
@property (assign, nonatomic) double doubleVal;
@property (strong, nonatomic) NSString *stringVal;
@property (strong, nonatomic) NSNumber *numberVal;
@property (strong, nonatomic) NSArray *arrayVal;
@property (strong, nonatomic) UIImage *imageVal;



@end
