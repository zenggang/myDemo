//
//  ExchangeNOSettingViewController.h
//  FlatUILearning
//
//  Created by gang zeng on 13-7-6.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    FormtypeExchangeNumberType =0,
    FormtypeBingdingQqType     =1,
    FormtypeAwardGoldType      =2,
    
} Formtype;

@interface ExchangeNOSettingViewController : BaseViewController<UITextFieldDelegate>

@property (nonatomic,assign) Formtype formType;

@end
