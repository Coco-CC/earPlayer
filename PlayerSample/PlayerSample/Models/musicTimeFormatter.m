//
//  musicTimeFormatter.m
//  PlayerSample
//
//  Created by co on 15/10/29.
//  Copyright © 2015年 caofarui. All rights reserved.
//

#import "musicTimeFormatter.h"

@implementation musicTimeFormatter

//格式化后的字符串时间
+(NSString *)getStringFormatBySconds:(float)sconds{
    //格式化时间，从浮点类型 转换成“00：00”字符串
    NSString *formatTime = [NSString stringWithFormat:@"%02ld:%02ld",(NSInteger)sconds/60,(NSInteger)sconds % 60];
    return formatTime;
}
+(float)getScondsFormatByString:(NSString *)string{
    NSArray *tempArr = [string componentsSeparatedByString:@":"];
    return [[tempArr firstObject] integerValue] * 60.0 + [[tempArr lastObject]integerValue];
}
@end
