//
//  PlayerConsole.h
//  PlayerSample
//
//  Created by co on 15/10/29.
//  Copyright © 2015年 caofarui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicInfo.h"
#import "PlayerManager.h"

@interface PlayerConsole : UIView



/**
 *
 *当每次准备播放一首歌时的方法
 *音乐模型类
 **/
-(void)prepareMusicWithMusicInfo:(MusicInfo *)musicInfo;




/**
 *
 *当音乐已经播放时所调用的方法
 * 格式化的时间字符串
 **/
-(void)playMusicWithFomateString:(NSString * )string;







@end
