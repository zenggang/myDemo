//
//  BaseListViewController.h
//  FlatUILearning
//
//  Created by gang zeng on 13-6-18.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableViewCell+FlatUI.h"

@interface BaseListViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end
