//
//  WeiXinAwardViewController.h
//  FlatUILearning
//
//  Created by gang zeng on 13-7-9.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    DescribeTypeWeiXin =0,
    DescribeTypeFiveStar =1,
} DescribeType;

@interface WeiXinAwardViewController : BaseViewController

@property (nonatomic,assign) DescribeType describeType;

@end
