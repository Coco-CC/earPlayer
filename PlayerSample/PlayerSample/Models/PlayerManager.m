//
//  PlayerManager.m
//  PlayerSample
//
//  Created by co on 15/10/28.
//  Copyright © 2015年 caofarui. All rights reserved.
//

#import "PlayerManager.h"
#import "URL.h"
#import "musicTimeFormatter.h"
@import AVFoundation;  //引入系统框架
@interface PlayerManager ()
@property (nonatomic,strong) NSMutableArray *playlistArray;
@property (nonatomic,strong) AVPlayer *player; //播放器属性
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger currentIndex;
@property (nonatomic,strong) NSString *playMode;

@end
@implementation PlayerManager
static PlayerManager *s_defaultManager = nil;
+(PlayerManager *)defaultManager{
    static  dispatch_once_t  oneToken;
    dispatch_once(&oneToken, ^{
        s_defaultManager = [[self alloc]init];
    });
    return  s_defaultManager;
}
-(instancetype)init{
    
    self = [super init];
    
    if (self) {
        self.currentIndex = - 1;
        //监听音乐播放完毕的方法
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didMusicFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:nil ];
    }
    
    return self;
}

//音乐播放完毕，播放下一首歌曲
-(void)didMusicFinished{
    
    
    [self musicpause];
    
    if ([self.playMode isEqualToString:@"desk_shuffle"]) {
        
        NSInteger indexs = arc4random() % self.playlistCount;
        [self prepareMusicWithIndex:indexs];
        
    }else{
        
        [self nextMusic];
        
    }
    [self musicPlay];
    
}

//设置音乐的播放模式
-(void)musicPlayMode:(NSString *)playMode{
    
    self.playMode = playMode;
    
}
-(void)setPlayMode:(NSString *)playMode{
    
    if (_playMode != playMode) {
        
        _playMode = nil;
        
        _playMode = playMode;
    }
}
/**
 *
 * 获取播放列表
 @param handler  当完成时回调的Block
 *
 **/



-(void)getPlaylistCompletionHandler:(void(^)())handler{
    
    
    
    //创建子线程
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSArray *tempArr = [NSArray arrayWithContentsOfURL:[NSURL URLWithString:kPlaylistURL]];
        
        
        // 每次调用该获取接口内容的方法  将数组中的内容清除
        
        [self.playlistArray removeAllObjects];
        
        for (NSDictionary *dic  in tempArr) {
            
            //  创建model对象
            MusicInfo *music = [[MusicInfo alloc]init];
            
            //向对象中的model 中的属性赋值
            [music setValuesForKeysWithDictionary:dic];
            
            [self.playlistArray addObject:music];
        }
        //返回主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //调用blocok通知外部
            handler();
            
        });
        
    });
    
    
}

-(NSUInteger)playlistCount{
    return  self.playlistArray.count;
}
#pragma mark - Lazy loading Method



-(NSMutableArray *)playlistArray{
    if (!_playlistArray ) {
        
        _playlistArray = [NSMutableArray array];
    }
    return _playlistArray;
    
}


-(AVPlayer *)player{
    
    
    if (!_player) {
        
        _player = [[AVPlayer alloc]init];
    }
    
    return _player;
    
}


-(void)prepareMusicWithIndex:(NSUInteger)index{
    
    
    
    if (self.currentIndex != index) {
        
        self.currentIndex = index;
        //获取当前音乐信息
        MusicInfo *musicInfo = [self getMusicInfoWithIndex:index];
        
        //实例化一个 playitem  作为Player 的“CD”
        AVPlayerItem *playerItem = [AVPlayerItem  playerItemWithURL:[NSURL URLWithString:musicInfo.mp3Url]];
        
        // 替换当前的PlayItem
        [self.player replaceCurrentItemWithPlayerItem:playerItem];
        
        //  [self musicPlay];
        
        
        if ([self.delegate respondsToSelector:@selector(didMusicCutWithMusicInfo:)]) {
            
            
            [self.delegate didMusicCutWithMusicInfo:musicInfo];
            
        }
        
        
    }
    
}

-(void)musicPlay{
    //实例化一个 定时器，并且调用频率为0.1秒 并且调用 “timerAction” 的频率为0.1秒
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    //播放器开始播放
    [self.player play];
}
//暂停
-(void)musicpause{
    [self.timer invalidate];
    
    self.timer = nil;
    [self.player pause];
}
-(void)timerAction{
    //代理的安全判断
    if ([self.delegate respondsToSelector:@selector(didPlayChangeStatus:)]) {
        
        //获取当前的播放的浮点类型的时间
        CGFloat currentTime = CMTimeGetSeconds(self.player.currentTime); //返回当前时间
        //歌曲播放时，向外部调用，改变状态的方法，并将格式化后的时间作为参数传输
        [self.delegate didPlayChangeStatus:[musicTimeFormatter getStringFormatBySconds:currentTime]];
    }
}
/**
 *
 *获取播放列表中的歌曲
 *@param index 获取哪一个
 @return 返回对应的歌曲信息
 **/
-(MusicInfo *)getMusicInfoWithIndex:(NSUInteger)index{
    return  self.playlistArray[index];
}
//调整播放进度
-(void)musicSeekToTime:(float)time{
    [self.player seekToTime:CMTimeMake(time, 1)];
}
//调整音量
-(void)musicVolume:(float)value{
    self.player.volume = value;
}
//上一首
-(void)upMusic{
    [self prepareMusicWithIndex:self.currentIndex - 1  < 0 ? self.playlistArray.count - 1 : self.currentIndex - 1];
}
//下一首
-(void)nextMusic{
    [self prepareMusicWithIndex:self.currentIndex + 1  < self.playlistCount ? self.currentIndex + 1 : 0 ];
}
@end
