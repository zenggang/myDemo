//
//  BaseViewController.h
//  FlatUILearning
//
//  Created by gang zeng on 13-6-3.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+FlatUI.h"
#import "UISlider+FlatUI.h"
#import "UIStepper+FlatUI.h"
#import "UITabBar+FlatUI.h"
#import "UINavigationBar+FlatUI.h"
#import "FUIButton.h"
#import "FUISwitch.h"
#import "UIFont+FlatUI.h"
#import "FUIAlertView.h"
#import "UIBarButtonItem+FlatUI.h"
#import "UIProgressView+FlatUI.h"
#import "FUISegmentedControl.h"
#import "UIImage+FlatUI.h"
#import "AppUtilities.h"
#import "McDownload.h"
#import "DMScrollingTicker.h"

@interface BaseViewController : UIViewController<FUIAlertViewDelegate>
 

#pragma mark Custom metod
-(DMScrollingTicker *) createTextScrollViewWithFrame:(CGRect) frame withTextArray:(NSArray *) textArray;
-(void) createNavigationRightButtonWithTitle:(NSString *) title action:(SEL) action;
-(void) createNavigationLeftButtonWithTitle:(NSString *) title action:(SEL) action;
-(FUIButton *) createFUIButtonWithFrame:(CGRect)frame cornerRadius:(float) cornerRadius clickAction:(SEL) action fontSize:(UIFont *) font buttonColor:(UIColor *)buttonColor shadowColor:(UIColor *)shadowColor titleColor:(UIColor *) titleColor withText:(NSString *) text;
-(void) showFUIAlertViewWithTitle:(NSString *) title message:(NSString *) message withTag:(int) tag  cancleButtonTitle:(NSString *) cancleTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
-(FUIAlertView *) CreateFUIAlertViewWithTitle:(NSString *) title message:(NSString *) message withTag:(int) tag  cancleButtonTitle:(NSString *) cancleTitle otherButtonTitles:(NSString *)otherButtonTitles,... NS_REQUIRES_NIL_TERMINATION;
-(UIView *) loadViewFromXibName:(NSString *) nibName;

-(McDownload *) downloadFileWithUrl:(NSString *) url fileName:(NSString *) fileName withDelegete:(id) delegate;
-(void) showMenuLeft;
-(void) showMenuRight;

@end 
