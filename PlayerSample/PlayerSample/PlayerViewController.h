//
//  PlayerViewController.h
//  PlayerSample
//
//  Created by co on 15/10/26.
//  Copyright © 2015年 caofarui. All rights reserved.
//

#import "ViewController.h"
@interface PlayerViewController : ViewController
@property (nonatomic,assign) NSInteger musicIndex;
+(PlayerViewController *)defaultManager;
@end
