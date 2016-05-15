//
//  PlayerManager.h
//  PlayerSample
//
//  Created by co on 15/10/28.
//  Copyright © 2015年 caofarui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicInfo.h"

@protocol PlayerManagerDelegate<NSObject>

/**
 *
 *当歌曲正在播放时 被一直调用的代理方法
 *time  格式化的时间字符串
 **/
-(void)didPlayChangeStatus:(NSString *)time;

/**
 *
 *当音乐切换时调用的代理方法
 * music 数据模型
 **/
-(void)didMusicCutWithMusicInfo:(MusicInfo *)music;

@end



@interface PlayerManager : NSObject

@property (nonatomic,assign,readonly) NSUInteger playlistCount; //播放列表中有多少个歌曲

@property (nonatomic,weak)   id<PlayerManagerDelegate> delegate;

+(PlayerManager *)defaultManager;


-(void)getPlaylistCompletionHandler:(void(^)())handler;


-(MusicInfo *)getMusicInfoWithIndex:(NSUInteger)index;


/**
 *
 *准备播放的歌曲，
 *列表中的第几首
 **/

-(void)prepareMusicWithIndex:(NSUInteger)index;

/**
 *
 *播放音乐
 *
 **/
-(void)musicPlay;

/**
 *
 *暂停音乐
 *
 **/
-(void)musicpause;



/**
 *
 *音乐时间跳转
 *time 跳转的秒数
 **/

-(void)musicSeekToTime:(float)time;


/**
 *
 *音乐音量的调整
 *value 0.0 ~ 1.0 区间的值
 **/

-(void)musicVolume:(float)value;


/**
 *
 *播放上一首
 *
 **/

-(void)upMusic;

/**
 *
 *播放下一首
 *
 **/
-(void)nextMusic;

/**
 *
 *设置音乐的播放模式
 *
 **/
-(void)musicPlayMode:(NSString *)playMode;
@end
