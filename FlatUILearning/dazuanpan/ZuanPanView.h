//
//  ZuanPanView.h
//  FlatUILearning
//
//  Created by gang zeng on 14-5-2.
//  Copyright (c) 2014年 gang zeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZuanpanViewDelegate <NSObject>
@required
-(void) zuanPanWillStartRolling;
-(void) zuanPanDidEndRolling;
@end

@interface ZuanPanView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,weak) id<ZuanpanViewDelegate> delegate;
@property (nonatomic,strong) UICollectionView *circleLightView;

-(void) setUpZuanPanViewWithTypeList:(NSMutableArray *) typeList;
-(void) startRollingToNumber:(int) number;
-(void) stopLightingAnimation;
@end