//
//  NSNumberFormatterHelper.m
//  NSNumberFormatterHelper
//
//  Created by leo on 2017/3/18.
//  Copyright © 2017年 leo. All rights reserved.
//

#import "NSNumberFormatterHelper.h"

@implementation NSNumberFormatterHelper

long const XHundredMillion = 100000000;
int const XTenThousant = 10000;
double const XMinusMillion = 0.000001;
float const XMinusTenThousant = 0.0001;

+ (NSNumberFormatterHelper *)shareInstance {
    static dispatch_once_t onceToken;
    static NSNumberFormatterHelper *numberFormatter = nil;
    dispatch_once(&onceToken, ^{
        numberFormatter = [[NSNumberFormatterHelper alloc] init];
    });
    return numberFormatter;
}

+ (NSString *)decimalFormatterFromString:(NSString *)string maximumFractionDigits:(NSUInteger )maximumFractionDigits
 minimumFractionDigits:(NSUInteger )minimumFractionDigits {
    NSNumberFormatter* currencyFormatter = [[NSNumberFormatter alloc] init];
    id result = [currencyFormatter numberFromString:string];
    if(!(result)) {
        return string;
    }else {
        [currencyFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [currencyFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [currencyFormatter setLocale:[NSLocale currentLocale]];
        // TODO: 如果只支持大陆需要强制设置
//        [currencyFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
        [currencyFormatter setMaximumFractionDigits:maximumFractionDigits];
        [currencyFormatter setMinimumFractionDigits:minimumFractionDigits];
        double absresult = [result doubleValue];
        if (absresult < 0) {
            currencyFormatter.positivePrefix = currencyFormatter.minusSign;
            absresult = fabs([result doubleValue]);
        }
        if(absresult >= XHundredMillion) {
            currencyFormatter.multiplier = [NSNumber numberWithDouble:XMinusMillion];
            // FIXME: 我们用亿标记，国外多用百万million标记 需国际化
            currencyFormatter.positiveSuffix = @"亿";//
            // FIXME: 上边的缩放只能设6位，此处做了二次计算 还需要继续跟踪
            return [currencyFormatter stringFromNumber:[NSNumber numberWithDouble:absresult / 100]];
        }else if(absresult >= XTenThousant) {
            currencyFormatter.multiplier = [NSNumber numberWithDouble:XMinusTenThousant];
            // FIXME: 我们用万标记，国外多用千thousand标记 需国际化
            currencyFormatter.positiveSuffix = @"万";
        }else {
            // TODO: nothing
        }
        return [currencyFormatter stringFromNumber:[NSNumber numberWithDouble:absresult]];
    }
}

+(NSNumberFormatter*) currencyFormatterWithNoFraction{
    NSNumberFormatter* currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [currencyFormatter setLocale:[NSLocale currentLocale]];
    [currencyFormatter setMaximumFractionDigits:0];
    
    return currencyFormatter;
}

+(NSNumberFormatter*) percentFormatter{
    NSNumberFormatter* percentFormatter = [[NSNumberFormatter alloc] init];
    [percentFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [percentFormatter setNumberStyle:NSNumberFormatterPercentStyle];
    [percentFormatter setLocale:[NSLocale currentLocale]];
    [percentFormatter setMinimumFractionDigits:2];
    
    return percentFormatter;
}

+(NSNumberFormatter*) basicFormatter{
    NSNumberFormatter* basicFormatter = [[NSNumberFormatter alloc] init];
    [basicFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    
    return basicFormatter;
}

@end
