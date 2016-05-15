//
//  PlayerlistViewController.m
//  PlayerSample
//
//  Created by co on 15/10/26.
//  Copyright © 2015年 caofarui. All rights reserved.
//

#import "PlayerlistViewController.h"
#import "PlayerViewController.h"
#import "PlayerManager.h"
#import "MusicInfo.h"
#import "PlaylistCell.h"

@interface PlayerlistViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *playlistTableView;


@property (nonatomic,strong) NSMutableArray *playlistArray;

@property (nonatomic,strong) PlayerManager *playManager;

@end

@implementation PlayerlistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationController.navigationBarHidden = NO; //隐藏navigation
    self.navigationItem.hidesBackButton = YES;
    
    self.navigationItem.title = @"双耳旁";
    self.playManager = [PlayerManager defaultManager];
    
      [self.playManager getPlaylistCompletionHandler:^{
        
       // NSLog(@"请求完成");
        
        [self.playlistTableView reloadData];
    } ];
    
}
- (IBAction)didClickPlayerButtonItem:(UIBarButtonItem *)sender {
    
    PlayerViewController *playerVC = [PlayerViewController defaultManager];
    
    [self.navigationController pushViewController:playerVC animated:YES];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.playManager.playlistCount;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    //获取对应的播放列表自定义的单元格
    PlaylistCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    MusicInfo *music = [self.playManager getMusicInfoWithIndex:indexPath.row];
    
    //cell.textLabel.text = music.name;
    [cell setCellWithMusicInfo:music];
    
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

 //   [self.playManager prepareMusicWithIndex:indexPath.row];
    PlayerViewController *playerVC = [PlayerViewController defaultManager];//[self.storyboard instantiateViewControllerWithIdentifier:@"PlayerViewController"];
    playerVC.musicIndex = indexPath.row;
 
    [self.navigationController pushViewController:playerVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
