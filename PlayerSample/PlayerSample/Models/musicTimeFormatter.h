//
//  musicTimeFormatter.h
//  PlayerSample
//
//  Created by co on 15/10/29.
//  Copyright © 2015年 caofarui. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface musicTimeFormatter : NSObject
/**
 *
 *将时间秒数装换为格式化后的字符串
 *
 **/
+(NSString *)getStringFormatBySconds:(float)sconds;
/**
 *
 *将格式化后的字符串转换为时间秒数
 *
 **/

+(float)getScondsFormatByString:(NSString *)string;
@end
