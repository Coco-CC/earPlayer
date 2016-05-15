//
//  PlayerConsole.m
//  PlayerSample
//
//  Created by co on 15/10/29.
//  Copyright © 2015年 caofarui. All rights reserved.
//

#import "PlayerConsole.h"
#import "musicTimeFormatter.h"

@interface PlayerConsole ()

@property (weak,nonatomic) IBOutlet UISlider *timeSlider;//i时间滑块
@property (weak,nonatomic) IBOutlet UILabel *currentTime;
@property (weak,nonatomic) IBOutlet  UISlider *volumeSilder;

@property (weak,nonatomic) IBOutlet UILabel *totalTime;

@property (weak,nonatomic) IBOutlet UIButton *upButton;

@property (weak,nonatomic) IBOutlet UIButton *nextButton;

@property (weak,nonatomic) IBOutlet UIButton *playButton;


@property (weak,nonatomic) IBOutlet UIButton *volumeButton;





@end

@implementation PlayerConsole


-(void)prepareMusicWithMusicInfo:(MusicInfo *)musicInfo{

    
    self.currentTime.text = @"00:00";
    
    //获取音乐模型中的毫秒 / 1000
    NSInteger seconds = [musicInfo.duration intValue] / 1000;
    
    // 使用音乐时间工具 将毫秒数转换为格式化后的字符串
    self.totalTime.text = [musicTimeFormatter getStringFormatBySconds:seconds];
    
    //设置时间滑竿的最大值
    self.timeSlider.maximumValue = seconds;
    
    
    self.timeSlider.minimumTrackTintColor = [UIColor redColor];
    [self.timeSlider setThumbImage:[UIImage imageNamed:@"timebar.png"] forState:(UIControlStateNormal)];
    [self.timeSlider setThumbImage:[UIImage imageNamed:@"timebar.png"] forState:(UIControlStateHighlighted)];
    
    
    self.volumeSilder.minimumTrackTintColor = [UIColor redColor];
    [self.volumeSilder setThumbImage:[UIImage imageNamed:@"timebar.png"] forState:(UIControlStateNormal)];
    [self.volumeSilder setThumbImage:[UIImage imageNamed:@"timebar.png"] forState:(UIControlStateHighlighted)];
    
    
    
}

-(void)playMusicWithFomateString:(NSString * )string{

    self.timeSlider.value =[musicTimeFormatter getScondsFormatByString:string];
    

    self.currentTime.text = string;

}

/**
 *
 *点击播放按钮
 *
 **/
-(IBAction)didPlayButtonClicked:(UIButton *)sender{


    if ([sender.titleLabel.text isEqualToString:@"播放"]) {
        
        [[PlayerManager defaultManager]musicPlay ];
        
        [sender setTitle:@"暂停" forState:(UIControlStateNormal)];
        
        [sender setImage:[UIImage imageNamed:@"pause1.png"] forState:(UIControlStateNormal)];
        [sender setImage:[UIImage imageNamed:@"pause.png"] forState:(UIControlStateHighlighted)];
        
    }else{
    [[PlayerManager defaultManager]musicpause ];
    [sender setTitle:@"播放" forState:(UIControlStateNormal)];
        
        [sender setImage:[UIImage imageNamed:@"player1.png"] forState:(UIControlStateNormal)];
        [sender setImage:[UIImage imageNamed:@"player.png"] forState:(UIControlStateHighlighted)];
        
        
        
    }
}

/**
 *
 *点击上一首的方法
 *
 **/
- (IBAction)didUpButtonClicked:(UIButton *)sender{

    [[PlayerManager defaultManager]upMusic];
     [sender setImage:[UIImage imageNamed:@"last.png"] forState:(UIControlStateHighlighted)];

}

/**
 *
 *点击下一首
 *
 **/
- (IBAction)didNextButtonClicked:(UIButton *)sender{

    [[PlayerManager defaultManager ] nextMusic];

[sender setImage:[UIImage imageNamed:@"next.png"] forState:(UIControlStateHighlighted)];

}

/**
 *
 *音乐进度条
 *
 **/

- (IBAction)didTimeSliderValueChanged:(UISlider *)sender{

    [[PlayerManager defaultManager]musicSeekToTime:sender.value];



}
/**
 *
 *时间进度条
 *
 **/

- (IBAction)didVolumeSliderValueChanged:(UISlider *)sender{
    
    
    [[PlayerManager defaultManager]musicVolume:sender.value];
    
    
}


/**
 *
 *静音键
 *
 **/
- (IBAction)didVolumeJing:(UIButton *)sender{


    
    if([sender.titleLabel.text isEqualToString:@"playT"]){
    
    
        [[PlayerManager defaultManager]musicVolume:0];
        self.volumeSilder.enabled = NO;
        [sender setImage:[UIImage imageNamed:@"yinliangjingyin.png"] forState:(UIControlStateNormal)];
        [sender setTitle:@"playN" forState:(UIControlStateNormal)];
    
    }else{
    
    
        [[PlayerManager defaultManager]musicVolume:self.volumeSilder.value];
         self.volumeSilder.enabled = YES;
        [sender setImage:[UIImage imageNamed:@"yinliang.png"] forState:(UIControlStateNormal)];
        [sender setTitle:@"playT" forState:(UIControlStateNormal)];
    
    }
    
    
    
    
}






@end
