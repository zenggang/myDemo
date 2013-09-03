//
//  GuagualeViewController.h
//  FlatUILearning
//
//  Created by gang zeng on 13-7-20.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import "BaseGoldViewController.h"
#import "iCarousel.h"
#import "TicketView.h"
@interface GuagualeViewController : BaseGoldViewController<TicketViewDelegate,iCarouselDataSource, iCarouselDelegate>

@property (nonatomic,weak) IBOutlet iCarousel *carouseView;

@end
