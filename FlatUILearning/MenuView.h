//
//  TopicSquareView.h
//  FlatUILearning
//
//  Created by gang zeng on 13-6-6.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MenuView : UIView
@property (nonatomic,assign) SetMenu *setMenu;
 
@property (nonatomic,strong)  UIImageView *menuImageView;
@property (nonatomic,weak) IBOutlet UILabel *titleLable;
@property (nonatomic,weak) IBOutlet UILabel *saveMoneyLable;
@property (nonatomic,weak) IBOutlet UILabel *priceLable;
@property (nonatomic,strong) IBOutlet UIProgressView *progressView;
@property (nonatomic,strong) UILabel *progressLable;

-(void) setUpViewWithSetMenu:(SetMenu *) setmenu;
-(void) setProgressWithProgress:(double) progress;
@end
