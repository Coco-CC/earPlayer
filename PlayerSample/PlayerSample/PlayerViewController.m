//
//  PlayerViewController.m
//  PlayerSample
//
//  Created by co on 15/10/26.
//  Copyright © 2015年 caofarui. All rights reserved.
//

#import "PlayerViewController.h"
#import "PlayerManager.h"
#import "MusicInfo.h"
#import "UIImageView+WebCache.h"
#import "PlayerConsole.h"

@interface PlayerViewController ()<UITableViewDataSource,UITableViewDelegate,PlayerManagerDelegate>
@property (nonatomic,strong) PlayerManager *playManager;
@property (weak, nonatomic) IBOutlet UIImageView *musicBackground;
@property (weak, nonatomic) IBOutlet UIImageView *musicPic;
@property (weak, nonatomic) IBOutlet UITableView *musicLyric;
@property (weak, nonatomic) IBOutlet PlayerConsole *playConcole;
@property (weak, nonatomic) IBOutlet UIView *musicBackgroundView; //存放图片的View
@property (weak, nonatomic) IBOutlet UIBarButtonItem *playModeButtonItem;
@property (nonatomic,strong) UIImageView  *musicImage;   //图像背后的背景图片   整体VIew 后面的那个视图 毛玻璃效果吓的那个视图
@property (nonatomic,strong) NSArray *lyricArray;
@property (nonatomic,strong) NSString *playMode ; //用于判断 播放模式，循环 单曲 随机
@property (nonatomic,assign) BOOL  isPifumo; // 皮肤的属性
@end
@implementation PlayerViewController
static PlayerViewController *s_defaultManager = nil;
+(PlayerViewController *)defaultManager{
    static  dispatch_once_t  oneToken;
    dispatch_once(&oneToken, ^{
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        if (s_defaultManager == nil) {
            s_defaultManager = [storyboard instantiateViewControllerWithIdentifier:@"PlayerViewController"];
        }
    });
    return  s_defaultManager;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //调用准备播放的歌曲同时获取到MusicInfo
    [self.playManager prepareMusicWithIndex:self.musicIndex];
    
}
//  因为使用单例界面改变了当前视图的生命周期，，导致ViewDidLoad 只可以执行一次
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.playManager = [PlayerManager defaultManager];
    self.playManager.delegate = self;
    self.musicLyric.backgroundColor = [UIColor clearColor]; //清除 tableView 的背景颜色
    
    //播放模式按钮的设置
    self.playMode = [[NSUserDefaults standardUserDefaults]objectForKey:@"playMode"];
    
    if ([self.playMode isEqualToString:@"desk_shuffle"]) {
        [self.playModeButtonItem setImage:[UIImage imageNamed:@"desk_shuffle.png"]];
        [self.playManager musicPlayMode:@"desk_shuffle"];
    }else {
        
        [self.playModeButtonItem setImage:[UIImage imageNamed:@"desk_loop.png"]];
        self.playMode = @"desk_loop";
        
        [self.playManager musicPlayMode:@"desk_loop"];
    }
    //改变约束的声明周期，提前  使storyboard加载的视图提前
    //切圆
    [self.musicPic layoutIfNeeded];
    [self.musicPic.layer setMasksToBounds:YES];
    [self.musicPic.layer setCornerRadius:self.musicPic.frame.size.width /2 ];
    
    [self.musicBackground layoutIfNeeded];
    
    [self.musicBackground.layer setMasksToBounds:YES];
    
    [self.musicBackground.layer setCornerRadius:self.musicBackground.frame.size.width/2];
     [self.playManager musicPlay];
    self.musicLyric.separatorStyle = UITableViewCellSeparatorStyleNone; //取消 分行线
    self.musicLyric.showsVerticalScrollIndicator = NO; //取消右侧的  侧滑线
    // Do any additional setup after loading the view.
    
    
   // [self.musicBackgroundView layoutIfNeeded];
    self.musicImage = [[UIImageView alloc]initWithFrame:self.view.frame];
    [self.musicBackgroundView addSubview:self.musicImage];
    [self.musicBackgroundView sendSubviewToBack:self.musicImage];
    
    [self.view addSubview:self.musicImage];
    [self.view sendSubviewToBack:self.musicImage];
}
//返回按钮
- (IBAction)didClickBackButtonItem:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
//点击播放模式按钮
- (IBAction)didClickPlayModeButtonItem:(UIBarButtonItem *)sender {
    if ([self.playMode isEqualToString:@"desk_loop"]) {
        [[NSUserDefaults standardUserDefaults]setObject:@"desk_shuffle" forKey:@"playMode"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        self.playMode = @"desk_shuffle";
        [self.playModeButtonItem setImage:[UIImage imageNamed:@"desk_shuffle.png"]];
        [self.playManager musicPlayMode:@"desk_shuffle"];
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:@"desk_loop" forKey:@"playMode"];
        
        [[NSUserDefaults standardUserDefaults]synchronize];
         self.playMode = @"desk_loop";
         [self.playModeButtonItem setImage:[UIImage imageNamed:@"desk_loop.png"]];
           [self.playManager musicPlayMode:@"desk_loop"];
    }
}
#pragma mark - playerManagerDelegate
//实现代理方法
-(void)didPlayChangeStatus:(NSString *)time{
    [self.playConcole playMusicWithFomateString:time];
    //便利当前数组中的元素，
    for (int i = 0; i < self.lyricArray.count; i++) {
        
        NSDictionary *dict = self.lyricArray[i];

        //找到  字典中的字符串 key
        if ([time isEqualToString:[[dict allKeys] lastObject]]) {
            //选中   选中的屏幕的中间UITableViewScrollPositionMiddle
            [self.musicLyric selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        }
        
    }
    self.musicPic.transform = CGAffineTransformRotate(self.musicPic.transform, M_PI / 360);
}
/**
 *
 *当音乐切换时调用的代理方法
 * music 数据模型
 **/

-(void)didMusicCutWithMusicInfo:(MusicInfo *)music{
    [self.musicPic sd_setImageWithURL:[NSURL URLWithString:music.picUrl] placeholderImage:[UIImage imageNamed:@"musicCache.png"]];
    
    self.navigationItem.title =music.name;
    
    //给控制台传值  （存放 时间 ，上一首 下一首  播放的 view）
    [self.playConcole prepareMusicWithMusicInfo:music];
    
    //将时间歌词添加到当前VC的数组中
    self.lyricArray = [NSArray arrayWithArray:music.timeForLyric];
    [self.musicLyric reloadData]; //刷新 歌词 tableView 界面

    [self.musicImage sd_setImageWithURL:[NSURL URLWithString:music.blurPicUrl] placeholderImage:[UIImage imageNamed:@"main_bg.png"]]; // 背景图片
   // UIImage *image = self.musicImage.image;

    // self.view.backgroundColor = [UIColor colorWithPatternImage:image];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.lyricArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *dict = self.lyricArray[indexPath.row];
    cell.textLabel.text = [dict allValues].firstObject;
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    [cell.textLabel setNumberOfLines:0];
    [cell.textLabel setFont:[UIFont systemFontOfSize:15.0]];
    
    //设置文字高亮颜色
    cell.textLabel.highlightedTextColor = [UIColor blackColor];
    
    cell.textLabel.textColor = [UIColor colorWithRed:164/ 255.0 green:160/255.0 blue:162/255.0 alpha:1];
    
    
    //自定义一个View 没有背景 用于 替换选中（高亮）状态下的cell 中的view
    UIView *view = [[UIView alloc]initWithFrame:cell.contentView.frame];
    view.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = view;
    
    // cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
