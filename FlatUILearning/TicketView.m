//
//  TicketView.m
//  FlatUILearning
//
//  Created by gang zeng on 13-7-23.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import "TicketView.h"

@implementation TicketView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void) setUpTicketWithinfo:(NSDictionary *) ticketInfo withTicketViewDelegate:(id) del
{
   
    _ticketInfo=ticketInfo;
    _buyButton.hidden=YES;
    self.delegate=del;
    
    int benjin=[[ticketInfo objectForKey:@"benjin"] intValue];
    double baobenRate=[[ticketInfo objectForKey:@"baobenRate"] doubleValue];
    
    [_tickeWorthLable setText:[NSString stringWithFormat:@"%d金币刮刮卡",benjin]];
    [_tickeMostAwardLable setText:[NSString stringWithFormat:@"最高回报:%d金币",benjin*3]];
    [_tickeRateLable setText:[NSString stringWithFormat:@"保本率:%0.f%@",baobenRate*100,@"%"]];
    [self recrateScrachView];
}

-(void) recrateScrachView
{
    if (_scratchView) {
        [_scratchView removeFromSuperview];
        _scratchView=nil;
    }
    _scratchView = [[STScratchView alloc] initWithFrame:_tickeLable.frame];
    [_scratchView setSizeBrush:30.0];
    UIView *hideView =[[UIView alloc ]initWithFrame:_scratchView.frame];
    hideView.backgroundColor=[UIColor silverColor];
    [_scratchView setHideView:hideView];
    _scratchView.delegate=self;
    [self.ticketTextMainView addSubview:_scratchView];
    int benjin=[[_ticketInfo objectForKey:@"benjin"] intValue];
    double baobenRate=[[_ticketInfo objectForKey:@"baobenRate"] doubleValue];
    
    int ticketValue =[self calculateCardValueWithBaobenRate:baobenRate andBenJin:benjin];
    [_tickeLable setText:[NSString stringWithFormat:@"%d金币",ticketValue]];
    _awardValue=ticketValue;
}


-(void) changeTicketToBuyModel
{
    _tickeImageView.image=[UIImage imageNamed:@"ticket_big"];
    [UIView animateWithDuration:0.5 animations:^{
        _tickeImageView.frame=CGRectMake(0, 0, 401, 119);
        _ticketTextMainView.frame=CGRectMake(100, 0, 311, 119);
        _buyButton.frame=CGRectMake(20, 41, 75, 35);
        
    }];
    _buyButton.hidden=NO;
}
-(void) changeTicketToBeforeModel
{
    _tickeImageView.image=[UIImage imageNamed:@"ticket_short"];
    [UIView animateWithDuration:0.5 animations:^{
        _tickeImageView.frame=CGRectMake(0, 0, 311, 119);
        _ticketTextMainView.frame=CGRectMake(0, 0, 311, 119);
        
    }];
    _buyButton.hidden=YES;
    [self recrateScrachView];
}

-(IBAction) buyTicket:(id) sender 
{
    [_delegate clickTheBuyButtonWithBenjin:[[_ticketInfo objectForKey:@"benjin"] intValue] WithAwardValue:_awardValue];
}

-(void) showTheTicketScratchArea
{
    [UIView animateWithDuration:0.5 animations:^{
        _tickeImageView.frame=CGRectMake(-100, 0, 401, 119);
        _ticketTextMainView.frame=CGRectMake(0, 0, 311, 119);
        _buyButton.frame=CGRectMake(-80, 41, 75, 35);
    }];

} 

-(void)didShowTheMainArea
{
    [_delegate didScratchTicket];
}

-(int) calculateCardValueWithBaobenRate:(double) baobenRate andBenJin:(int) benjin
{
    double awardRate=(1-baobenRate)*0.5;
    double loseRate=awardRate*2;
    double equalRate=1-awardRate-loseRate;
    int k=5;
    if (benjin>=100) {
        k=10;
    }
    
    double rate =arc4random_uniform(1000) / 1000.0;
    int kRate=arc4random_uniform(k)+1;
    int kValue=(benjin/k)*kRate;
    if (rate<=loseRate) {
        return benjin-kValue;
    } else if(rate<=(loseRate+equalRate)){
        return benjin;
    }else{
        return benjin+(kValue*1.1);
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
