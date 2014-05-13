//
//  lightCell.h
//  FlatUILearning
//
//  Created by gang zeng on 14-5-8.
//  Copyright (c) 2014年 gang zeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface lightCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *lightImageView;
-(void) setLightImageWithType:(int) type;
@end
