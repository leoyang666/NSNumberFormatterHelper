//
//  NSNumberFormatterHelper.h
//  NSNumberFormatterHelper
//
//  Created by leo on 2017/3/18.
//  Copyright © 2017年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>

extern long const XHundredMillion;
extern int const XTenThousant;
extern double const XMinusMillion;
extern float const XMinusTenThousant;

@interface NSNumberFormatterHelper : NSObject

+ (NSNumberFormatterHelper *)shareInstance;
// 返回万，亿，千位符用,分隔样式
+ (NSString *)decimalFormatterFromString:(NSString *)string maximumFractionDigits:(NSUInteger )maximumFractionDigits
                    minimumFractionDigits:(NSUInteger )minimumFractionDigits;
@end
