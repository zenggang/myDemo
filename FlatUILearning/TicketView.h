//
//  TicketView.h
//  FlatUILearning
//
//  Created by gang zeng on 13-7-23.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STScratchView.h"

@protocol TicketViewDelegate <NSObject>
-(void) didScratchTicket;
-(void) clickTheBuyButtonWithBenjin:(int) benjin WithAwardValue:(int) awardValue;
@end

@interface TicketView : UIView<STScratchViewDelegate>


@property (nonatomic,weak) IBOutlet UILabel *tickeLable;
@property (nonatomic,weak) IBOutlet UILabel *tickeMostAwardLable;
@property (nonatomic,weak) IBOutlet UILabel *tickeWorthLable;
@property (nonatomic,weak) IBOutlet UILabel *tickeRateLable;
@property (nonatomic,weak) IBOutlet UIImageView *tickeImageView;
@property (nonatomic,weak) IBOutlet UIButton *buyButton;
@property (nonatomic,weak) IBOutlet UIView *ticketTextMainView;
@property (nonatomic, strong)  STScratchView *scratchView;
@property (nonatomic,assign) int awardValue;
@property (nonatomic,strong) NSDictionary *ticketInfo;
@property (nonatomic,weak) id<TicketViewDelegate> delegate;

-(void) setUpTicketWithinfo:(NSDictionary *) ticketInfo withTicketViewDelegate:(id) del;
-(void) changeTicketToBuyModel;
-(void) changeTicketToBeforeModel;
-(void) showTheTicketScratchArea;
@end

