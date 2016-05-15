//
//  PlaylistCell.m
//  PlayerSample
//
//  Created by co on 15/10/28.
//  Copyright © 2015年 caofarui. All rights reserved.
//

#import "PlaylistCell.h"
#import "UIImageView+WebCache.h"
@interface PlaylistCell ()
@property (weak, nonatomic) IBOutlet UIImageView *musciImageView;
@property (weak, nonatomic) IBOutlet UILabel *musicName;
@property (weak, nonatomic) IBOutlet UILabel *singerName;
@end


@implementation PlaylistCell





-(void)setCellWithMusicInfo:(MusicInfo *)music{

    
 //   self.backgroundColor = [UIColor clearColor];
    self.musicName.text = music.name;
    self.singerName.text = music.singer;
    
    [self.musciImageView sd_setImageWithURL:[NSURL URLWithString:music.picUrl] placeholderImage:[UIImage imageNamed:@"musicCache.png"]];

}


@end
