//
//  MusicInfo.m
//  PlayerSample
//
//  Created by co on 15/10/28.
//  Copyright © 2015年 caofarui. All rights reserved.
//

#import "MusicInfo.h"
@implementation MusicInfo
-(instancetype)init{
    self = [super init];
    if (self) {
        //实例化时间歌词的数组
        self.timeForLyric = [NSMutableArray array];
    }
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }else if([key isEqualToString:@"lyric"]){
        
        [self formatLyricWithLyricStr:value];
    }
}
-(void)formatLyricWithLyricStr:(NSString *) str{
    //截取歌词
    //以 “\n” 拆解字符串：“[00:00.000] ABCD”
    NSArray *returnArr = [str componentsSeparatedByString:@"\n"];
    for (NSString *tempStr in returnArr) {
        
        if (![tempStr isEqualToString:@""]) {
            
            //以“]” 拆解字符串    结果 （ “[00:00.00”    “ABCD”）
            NSArray *lyricAndTimeArr = [tempStr componentsSeparatedByString:@"]"];
            //将时间截取成想要的格式  @“00：00” 作为字典的 key
            NSString *timeKey = [[lyricAndTimeArr firstObject]substringWithRange:NSMakeRange(1,5)];
            
            //以“00:00 作为字典的key   “ABCD“ (数组的最后一位)作为字典的value”
            NSDictionary *lyricDic = @{timeKey:[lyricAndTimeArr lastObject]};
            
            //时间歌词的字典 （单句） 添加到数组中
            [self.timeForLyric addObject:lyricDic];
        }
    }
}
@end
