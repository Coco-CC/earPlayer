//
//  RootViewController.m
//  PlayerSample
//
//  Created by co on 15/10/30.
//  Copyright © 2015年 caofarui. All rights reserved.
//

#import "RootViewController.h"
#import "PlayerlistViewController.h"
@interface RootViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *guideScrolView;
@property (strong, nonatomic) UIPageControl *guidePageControl;


@property (nonatomic,strong) NSMutableArray *imageArray;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES; //隐藏navigation
    

    
    BOOL isFisetInt = [[NSUserDefaults standardUserDefaults]boolForKey:@"isFisetInt"];
    if (isFisetInt) {
        [self layoutBroadScrollView];
        [self layoutPageControl];
        
        
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isFisetInt"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    }else{
    
        PlayerlistViewController *playLVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PlayerlistViewController"];
        [self.navigationController pushViewController:playLVC animated:YES];
    
    }
    
 
    
    
    // Do any additional setup after loading the view.
}



-(void)layoutBroadScrollView{

    
    
    self.guideScrolView.delegate = self;
    self.guideScrolView.contentSize =CGSizeMake(self.view.frame.size.width * 3, self.view.frame.size.height);

    self.imageArray = [NSMutableArray array];
    for (int i = 1; i < 4; i ++) {
        
        NSString *imageName = [NSString stringWithFormat:@"guide_%d.jpg",i];
        UIImage *image = [UIImage imageNamed:imageName];
      
        
        UIImageView *bImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * (i - 1), 0, self.view.frame.size.width, self.view.frame.size.height)];;
        
        
        bImageView.image = image;
        
        [self.guideScrolView addSubview:bImageView];
        
        
        
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    
    button.frame = CGRectMake(self.view.frame.size.width* 2 + self.view.frame.size.width/2 - 50, self.view.frame.size.height-150, 100,40);
    
    [button setTitle:@"进入应用" forState:(UIControlStateNormal)];
    [button setBackgroundImage:[UIImage imageNamed:@"btn_follow"] forState:(UIControlStateNormal)];
    
    [button setTitleColor:[UIColor greenColor] forState:(UIControlStateNormal)];
    
    
    
    [button addTarget:self action:@selector(didIntAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    [self.guideScrolView addSubview:button];
    
}

-(void)didIntAction:(UIButton *)button{


    PlayerlistViewController *playLVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PlayerlistViewController"];
    
    
    [self.navigationController pushViewController:playLVC animated:YES];
    
    
    

}





-(void)layoutPageControl{

    
    self.guidePageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 50, self.view.frame.size.height - 50, 100, 30)];
    
    self.guidePageControl.numberOfPages = 3;
    self.guidePageControl.currentPage = 0;
    
    self.guidePageControl.currentPageIndicatorTintColor = [UIColor greenColor];
    
    self.guidePageControl.pageIndicatorTintColor = [UIColor grayColor];
    
    
    [self.view addSubview:self.guidePageControl];
    

    [self.guidePageControl addTarget:self action:@selector(pageControlAction:) forControlEvents:(UIControlEventValueChanged)];
    

}


-(void)pageControlAction:(UIPageControl *)pageControl{

    [self.guideScrolView setContentOffset:CGPointMake(pageControl.currentPage * self.view.frame.size.width, 0) animated:YES];

}

//结束动画效果
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    self.guidePageControl.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;

    
}














- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
