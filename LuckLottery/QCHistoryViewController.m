//
//  QCHistoryViewController.m
//  LuckLottery
//
//  Created by 武 孙 on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "QCHistoryViewController.h"

@interface QCHistoryViewController ()

@end

@implementation QCHistoryViewController
@synthesize luckItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self == [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        // 创建广告视图，此处使用的是测试ID，请登陆多盟官网（www.domob.cn）获取新的ID
        _dmAdView = [[DMAdView alloc] initWithPublisherId:@"56OJyM1ouMGoULfJaL" size:DOMOB_AD_SIZE_320x50];
        // 设置广告视图的位置
        _dmAdView.frame = CGRectMake(0, 0, DOMOB_AD_SIZE_320x50.width, DOMOB_AD_SIZE_320x50.height);
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
     // 设置导航栏按钮和标题
    if (luckItem.btType < kLuckItemTypeCST)
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(modifyLuckItem:)];
    }
    
    self.navigationItem.title = self.luckItem.strName;
    
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
    // e.g. self.myOutlet = nil;
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 30 + (_bADLoadOK ? 1 : 0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HistoryTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    int row = [indexPath row];
    if (_bADLoadOK) // 预留广告位
    {
        if (row == 0)
        {
            cell.textLabel.text = @"";
            return cell;
        }
        else
            row --;
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%d 2012101期 2012-01-01 试机号：123 开奖号：234 2 3 5 中1个", row];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - 
- (void)modifyLuckItem:(id)sender
{
    QCLuckItemDateSetViewController *dateSetVC = [[QCLuckItemDateSetViewController alloc] initWithNibName:@"QCLuckItemDateSetViewController" bundle:nil];
    dateSetVC.luckItem = luckItem;
    [self.navigationController pushViewController:dateSetVC animated:YES];
}
@end
