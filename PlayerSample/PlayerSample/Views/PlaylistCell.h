//
//  PlaylistCell.h
//  PlayerSample
//
//  Created by co on 15/10/28.
//  Copyright © 2015年 caofarui. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MusicInfo.h"
@interface PlaylistCell : UITableViewCell


/**
 *
 *设置单元格使用信息对应赋值
 *@param musicInfo 音乐信息
 **/

-(void)setCellWithMusicInfo:(MusicInfo *)music;

@end
