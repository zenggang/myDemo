//
//  ViewController.h
//  FlatUILearning
//
//  Created by gang zeng on 13-5-16.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "iCarousel.h"
#import "NSMutableArray+SSToolkitAdditions.h"
#import "QumiBannerAD.h"


@interface ViewController :BaseViewController <iCarouselDataSource, iCarouselDelegate,McDownloadDelegate,QumiBannerADDelegate>


@property (nonatomic,strong) iCarousel *carouseView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *unDownLoadPicArray;
@property (nonatomic,retain)  QumiBannerAD  *qumiBannerAD;

@end
