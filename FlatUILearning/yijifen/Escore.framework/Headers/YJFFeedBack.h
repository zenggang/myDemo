//
//  FeedBackViewController.h
//  yjfSDKDemo_beta1
//
//  Created by emaryjf on 13-5-14.
//  Copyright (c) 2013年 emaryjf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJFFeedBack : UIViewController<UITextViewDelegate,NSURLConnectionDelegate>
@property (nonatomic,retain) UITextView *text;
@property (nonatomic,retain) UITextView *emailAddr;
@property (nonatomic,retain) NSMutableData *receivedData;
@property (assign) UILabel *label1;
@property (assign) UILabel *label2;

@property (assign) UILabel *title_demo;
@property (assign) UIButton *button;
@property (assign) UIImageView *logoImage ;
  
@end
