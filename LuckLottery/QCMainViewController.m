//
//  QCViewController.m
//  LuckLottery
//
//  Created by 武 孙 on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "QCMainViewController.h"
#import "QCLuckItemTableViewCell.h"

@interface QCMainViewController ()

@end

@implementation QCMainViewController
@synthesize luckItemArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        // 设置导航栏按钮和标题
   //     self.navigationItem.leftBarButtonItem = self.editButtonItem;
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNew:)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(downloadData:)];

        self.navigationItem.title = @"幸运彩票-福彩3D";   // LOTTERY
        
        NSArray *array = [[NSUserDefaults standardUserDefaults] arrayForKey:@"LuckItems"];
        if ([array count] > 0) // 直接使用设置中的值
        {
            self.luckItemArray = [[NSMutableArray alloc] initWithArray:array];
        }
        else  // 初始化
        {
            self.luckItemArray = [[NSMutableArray alloc] init];
            QCLuckItem *luckItemDate = [QCLuckItem luckItemWithType:kLuckItemTypeDate andName:@"幸运日关注码"];
            QCLuckItem *luckItemNumber = [QCLuckItem luckItemWithType:kLuckItemTypeNumber andName:@"幸运数字关注码"];
      /*      QCLuckItem *luckItemPerson = [QCLuckItem luckItemWithType:kLuckItemTypePerson andName:@"贵人关注码"];
            QCLuckItem *luckItemAddress = [QCLuckItem luckItemWithType:kLuckItemTypeAddress andName:@"宝地关注码"];
            QCLuckItem *luckItemCarNumber = [QCLuckItem luckItemWithType:kLuckItemTypeCarNumber andName:@"车牌号关注码"];
     */
            QCLuckItem *luckItemCST = [QCLuckItem luckItemWithType:kLuckItemTypeCST andName:@"彩神通关注码"];
           
            // LOTTERY
            [self.luckItemArray addObject:luckItemCST];
            [self.luckItemArray addObject:luckItemDate];
            [self.luckItemArray addObject:luckItemNumber];
        }
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - UITableViewDelegate and UITableViewDataSource Method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"开奖日期：2012-06-10 第2012100期 \n试机号：123 开奖号：345";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [luckItemArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"LuckItemTableViewCell";
    QCLuckItemTableViewCell *cell = (QCLuckItemTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        UIViewController *vc = [[UIViewController alloc] initWithNibName:@"QCLuckItemTableViewCell" bundle:nil];

        cell = (QCLuckItemTableViewCell *)vc.view;

       /* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;*/
    }
    
    int nIndex = [indexPath row];
    QCLuckItem *luckItem = [self.luckItemArray objectAtIndex:nIndex];
    cell.labelName.text = luckItem.strName;
    cell.lableValue.text = (luckItem.strValue == nil) ?  @"（未设置）" : luckItem.strValue;
    
    return (UITableViewCell *)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    QCLuckItem *luckItem = [self.luckItemArray objectAtIndex:[fromIndexPath row]];
    [self .luckItemArray insertObject:luckItem atIndex:[toIndexPath row]];
    [self.luckItemArray removeObjectAtIndex:[fromIndexPath row]];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}
@end
