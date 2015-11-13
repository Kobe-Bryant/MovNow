//
//  MNGuideViewCtrl.m
//  Movnow
//
//  Created by HelloWorld on 15/4/14.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNGuideViewCtrl.h"
#import "MNDeviceMainViewCtrl.h"

#define ImageCount 3

@interface MNGuideViewCtrl ()<UIScrollViewDelegate>

//滚动视图
@property (nonatomic,strong) UIScrollView *guideView;
//分页标识
@property (nonatomic,strong) UIPageControl *pageCtrl;
//进入按钮
@property (nonatomic,strong) UIButton *enterBtn;

@end

@implementation MNGuideViewCtrl

- (UIScrollView *)guideView
{
    if (_guideView == nil) {
        _guideView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        _guideView.contentSize = CGSizeMake(_guideView.frame.size.width * ImageCount, _guideView.frame.size.height);
        _guideView.delegate = self;
        _guideView.showsHorizontalScrollIndicator = NO;
        _guideView.showsVerticalScrollIndicator = NO;
        _guideView.pagingEnabled = YES;
        _guideView.bounces = NO;
    }
    return _guideView;
}

- (UIPageControl *)pageCtrl
{
    if (_pageCtrl == nil) {
        _pageCtrl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 57, SCREEN_WIDTH, 37)];
        _pageCtrl.numberOfPages = ImageCount;
        _pageCtrl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageCtrl.currentPageIndicatorTintColor = [UIColor colorWith8BitRed:136 green:96 blue:96];
    }
    return _pageCtrl;
}

-(UIButton *)enterBtn
{
    if (_enterBtn == nil) {
        _enterBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _enterBtn.backgroundColor = [UIColor clearColor];
        [_enterBtn addTarget:self action:@selector(enterBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_enterBtn setFrame:CGRectMake(SCREEN_WIDTH/2 - 60, SCREEN_HEIGHT *0.8, 120, 40)];
    }
    return _enterBtn;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    for (NSInteger i = 0; i < ImageCount; i ++) {
        
        UIImageView *guideImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        guideImage.userInteractionEnabled=YES;
        guideImage.contentMode = UIViewContentModeScaleAspectFill;
        
        switch ([[MNLanguageService shareInstance] getCurrentLanguage]) {
            case CurrentLanguageTypeChineseSimple:
            {
                guideImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@chinese_guide%ld@2x.jpg",_Image_Guide_Prefix,i + 1]];
            }
                break;
            case CurrentLanguageTypeEnglish:
            {
                guideImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@eng_guide%ld@2x.jpg",_Image_Guide_Prefix,i + 1]];
            }
                break;
            case CurrentLanguageTypeSpanish:
            {
                guideImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@rus_guide%ld@2x.jpg",_Image_Guide_Prefix,i + 1]];
            }
                break;
            default:
                break;
        }
        
        if (i == ImageCount - 1) {
            [guideImage addSubview:self.enterBtn];
        }
        
        [self.guideView addSubview:guideImage];
    }
    [self.view addSubview:self.guideView];
    [self.view addSubview:self.pageCtrl];
}

#pragma mark - 跳转到登陆界面
-(void)enterBtnClick
{
    if (_pushType == GuideVcDismissTypeFirstLaunch) {
        [UIApplication sharedApplication].keyWindow.rootViewController = [[MNBaseNavigationCtrl alloc]initWithRootViewController:[[MNDeviceMainViewCtrl alloc]initWithNibName:@"MNDeviceMainViewCtrl" bundle:nil]];
    }else if (_pushType == GuideVcDismissTypeSystemSetting){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.guideView) {
        self.pageCtrl.currentPage = scrollView.contentOffset.x / SCREEN_WIDTH;
    }
}

@end