//
//  QCViewController.m
//  LuckLottery
//
//  Created by 武 孙 on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "QCMainViewController.h"
#import "QCLuckItemTableViewCell.h"
#import "QCHistoryViewController.h"

@interface QCMainViewController ()

@end

@implementation QCMainViewController
@synthesize luckItemArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        // 创建广告视图，此处使用的是测试ID，请登陆多盟官网（www.domob.cn）获取新的ID
        _dmAdView = [[DMAdView alloc] initWithPublisherId:@"56OJyM1ouMGoULfJaL" size:DOMOB_AD_SIZE_320x50];
        // 设置广告视图的位置
        _dmAdView.frame = CGRectMake(0, 0, DOMOB_AD_SIZE_320x50.width, DOMOB_AD_SIZE_320x50.height);
        
        // 获取设置
        NSArray *array = [[NSUserDefaults standardUserDefaults] arrayForKey:@"LuckItems"];
        if ([array count] > 0) // 直接使用设置中的值
        {
            self.luckItemArray = [[NSMutableArray alloc] initWithArray:array];
        }
        else  // 初始化
        {
            self.luckItemArray = [[NSMutableArray alloc] init];
            QCLuckItem *luckItemDate = [QCLuckItem luckItemWithType:kLuckItemTypeDate andName:@"幸运日推荐码"];
            QCLuckItem *luckItemNumber = [QCLuckItem luckItemWithType:kLuckItemTypeNumber andName:@"幸运数字推荐码"];
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
    // 设置导航栏按钮和标题
    //     self.navigationItem.leftBarButtonItem = self.editButtonItem;
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNew:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(downloadData:)];
    
    self.navigationItem.title = @"福彩3D幸运码";   // LOTTERY
    
    _bADLoadOK = NO;
    _dmAdView.delegate = self;              // 设置 Delegate
    _dmAdView.rootViewController = self;    // 设置 RootViewController
    [self.view addSubview:_dmAdView];       // 将广告视图添加到父视图中
    [_dmAdView loadAd];                     // 开始加载广告
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [_dmAdView removeFromSuperview]; // 将广告试图从父视图中移除
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    _dmAdView.delegate = nil;
    _dmAdView.rootViewController = nil;
}

#pragma mark - DMAdViewDelegate Method
// 成功加载广告后，回调该方法
- (void)dmAdViewSuccessToLoadAd:(DMAdView *)adView
{
    _bADLoadOK = YES;
    [self.tableView reloadData];
}

// 加载广告失败后，回调该方法
- (void)dmAdViewFailToLoadAd:(DMAdView *)adView withError:(NSError *)error
{
    _bADLoadOK = NO;
    [_dmAdView loadAd]; // 重新加载
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
    [cell setNumber:nIndex AtIndex:0];

    return (UITableViewCell *)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60 + (_bADLoadOK ? 50 : 0);
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
     QCHistoryViewController *detailViewController = [[QCHistoryViewController alloc] initWithNibName:@"QCHistoryViewController" bundle:nil];
     detailViewController.luckItem = [self.luckItemArray objectAtIndex:[indexPath row]];
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark -
- (void)downloadData:(id)sender
{
    NSString *strURL = [NSString stringWithFormat:@"http://software.pinble.com/cstdata2010/debug/cstdata_sz.asp?ver=2&lastdate=0&lasttime=0&lotteryid=11000130&lastissue=%d", 2012001];
    NSURL *url = [NSURL URLWithString:strURL];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (data == nil)
    {
        return ;       // 下载失败，网络不通？
    }
    int nBufLen = [data length];
    if(nBufLen < 2)
	{
        return ;       // 下载失败，数据长度不够
	}
}

@end
