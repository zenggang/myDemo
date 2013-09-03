//
//  goldIntroductionViewController.m
//  FlatUILearning
//
//  Created by gang zeng on 13-6-27.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import "goldIntroductionViewController.h"

@interface goldIntroductionViewController ()

@end

@implementation goldIntroductionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.slidingViewController setAnchorLeftPeekAmount:20];
    self.slidingViewController.underRightWidthLayout = ECVariableRevealWidth;
    UITextView *lable =(UITextView *) [self.view viewWithTag:11];
    lable.font=[UIFont boldFlatFontOfSize:17];
    lable.textColor=GREEN_COLOR;
    UITextView *lable2 =(UITextView *) [self.view viewWithTag:12];
    lable2.font=[UIFont boldFlatFontOfSize:20];
    lable2.textColor=GREEN_COLOR;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
