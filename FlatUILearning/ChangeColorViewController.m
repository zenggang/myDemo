//
//  ChangeColorViewController.m
//  FlatUILearning
//
//  Created by gang zeng on 13-7-13.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import "ChangeColorViewController.h"

@implementation ChangeColorViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"变更主题";
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.tableView setBackgroundView:nil];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone; 
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableView
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section==0) {
        return APPDELEGATE.colorDict.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identity =@"cell";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identity];
    
    NSString *color = APPDELEGATE.colorDict.allKeys[indexPath.row];
    NSString *describeText=[APPDELEGATE.colorDict valueForKey:color];
    
    if (!cell) {
        cell = [UITableViewCell configureFlatCellWithColor:[UIColor colorFromHexCode:color] selectedColor:[UIColor whiteColor] style:UITableViewCellStyleDefault reuseIdentifier:identity];
        [cell setSeparatorHeight:1  ];
        UILabel *amountLable=[TTLabel createLabeWithTxt:@"＞" Frame:CGRectMake(250, 14, 40, 24) Font:[UIFont boldFlatFontOfSize:20] textColor:[UIColor whiteColor] backGroudColor:[UIColor clearColor]];
        amountLable.tag=520;
        amountLable.textAlignment=NSTextAlignmentRight;
        [cell.contentView addSubview:amountLable];
    }
    
    cell.textLabel.text=describeText;
    cell.textLabel.font=[UIFont boldFlatFontOfSize:17];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
    NSString *color = APPDELEGATE.colorDict.allKeys[indexPath.row];
    
    APPDELEGATE.sysColor=[UIColor colorFromHexCode:color];
    APPDELEGATE.sysButtonShadowColor=[UIColor colorFromHexCode:[APPDELEGATE.colorbuttonShadowDict objectForKey:color]];
    [[NSUserDefaults standardUserDefaults] setValue:color forKey:@"sysColor"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_VIEW_TO_IDENTIFIER object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"settingViewController",@"identifier",color,@"ischangeColor", nil]];
}
@end
