//
//  TViewController.m
//  TCardView
//
//  Created by 1370254410@qq.com on 04/19/2019.
//  Copyright (c) 2019 1370254410@qq.com. All rights reserved.
//

#import "TViewController.h"
#import "TcardView.h"


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface TViewController ()

@end

@implementation TViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    TCardView *cardView = [[TCardView alloc] initWithFrame:CGRectMake(0, 60, kScreenWidth, kScreenHeight - 200)];
    cardView.isOpenAutoScroll = NO;
    cardView.isEditing = YES;
    cardView.imageArr = @[@"pic0", @"pic1", @"pic2", @"pic3", @"pic4"];
    [self.view addSubview:cardView];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
