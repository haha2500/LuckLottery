//
//  QCHistoryViewController.m
//  LuckLottery
//
//  Created by 武 孙 on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "QCHistoryViewController.h"
#import "QCHistoryTableViewCell.h"
#import "QCDataStore.h"
#import "QCLuckItemDateSetViewController.h"
#import "QCLuckItemNumSetViewController.h"
#import "QCMainViewController.h"

@interface QCHistoryViewController ()

@end

@implementation QCHistoryViewController
@synthesize luckItem, mainVCForIPad;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self == [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        CGSize sizeAD = /*([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) ?DOMOB_AD_SIZE_728x90 : */DOMOB_AD_SIZE_320x50;
        
        // 创建广告视图，此处使用的是测试ID，请登陆多盟官网（www.domob.cn）获取新的ID，测试ID：56OJyM1ouMGoULfJaL
        // _dmAdView = [[DMAdView alloc] initWithPublisherId:@"56OJyM1ouMGoULfJaL" size:sizeAD]; // TEST 测试ID
        _dmAdView = [[DMAdView alloc] initWithPublisherId:@"56OJz/2YuMyvaSJlPj" size:sizeAD]; // 正式ID
        // 设置广告视图的位置
        int nXOffset = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) ? 200 : 0;
        _dmAdView.frame = CGRectMake(nXOffset, 0, sizeAD.width, sizeAD.height);
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

- (void)viewWillAppear:(BOOL)animated
{
    [[self tableView] reloadData];
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
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) 
    {
        return YES;
    }
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    _dmAdView.delegate = nil;
    _dmAdView.rootViewController = nil;
}

- (void)resetLuckItemForIPad
{
    // 设置导航栏按钮和标题
    if (luckItem.btType < kLuckItemTypeCST)
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(modifyLuckItem:)];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    self.navigationItem.title = self.luckItem.strName;
    [[self tableView] reloadData];
}

#pragma mark - DMAdViewDelegate Method
// 成功加载广告后，回调该方法
- (void)dmAdViewSuccessToLoadAd:(DMAdView *)adView
{
    NSLog(@"[HistoryViewController] success to load ad.");
    _bADLoadOK = YES;
    [self.tableView reloadData];  
}

// 加载广告失败后，回调该方法
- (void)dmAdViewFailToLoadAd:(DMAdView *)adView withError:(NSError *)error
{
    NSLog(@"[HistoryViewController] fail to load ad. %@", error);
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
    NSArray *dataItems = [[QCDataStore defaultStore] dataItemArray];
    return (([dataItems count] > 0) ? 31 : 1) + (_bADLoadOK ? 1 : 0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[QCDataStore defaultStore] dataItemArray] count] == 0)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nodatacell"];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nodatacell"];
        }
        cell.textLabel.text = (!_bADLoadOK || [indexPath row] == 1) ? @"请点击上面的“刷新”按钮获取最新数据" : @"";
        return cell;
    }
    
    static NSString *CellIdentifier = @"HistoryTableViewCell";
    QCHistoryTableViewCell *cell = (QCHistoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSString *nibName = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) ? @"QCHistoryTableViewCell_IPad" : @"QCHistoryTableViewCell";
        UIViewController *vc = [[UIViewController alloc] initWithNibName:nibName bundle:nil];
        
        cell = (QCHistoryTableViewCell *)vc.view;
    }
    // Configure the cell...
    int row = [indexPath row];
    if (_bADLoadOK) // 预留广告位
    {
        if (row == 0)
        {
            cell.lableIssue.text = cell.lableMatchCount.text = cell.lableNums.text = @"";
            [cell.imageBallView removeAllBalls];
            return cell;
        }
        else
            row --;
    }
    
    Byte btRecmdNums[8] = {0}, btNumberCount = [[QCDataStore defaultStore] numberCount];
    int nMatchCount = 0;
    
    if (row == 0)   // 预测数据
    {
        QCDataItem *dataItem = [[QCDataStore defaultStore] dataItemForecast];
        
        cell.lableIssue.text = [NSString stringWithFormat:@"%@  第%@期  试机号 %@", [dataItem dateString], [dataItem issueString], [dataItem testNumbersString]];
        cell.lableNums.text = @"开奖号（无）";
        if ([luckItem getRecmdNums:btRecmdNums atIndex:-1 matchCount:&nMatchCount] == 0)
        {
            nMatchCount = -2;
        }
        else
        {
            nMatchCount = -1;
        }
    }
    else    // 历史数据
    {
        NSArray *dataItems = [[QCDataStore defaultStore] dataItemArray];
        int nIndex = [dataItems count] - row;
        QCDataItem *dataItem = [dataItems objectAtIndex:nIndex];
        
        cell.lableIssue.text = [NSString stringWithFormat:@"%@  第%@期  试机号 %@", [dataItem dateString], [dataItem issueString], [dataItem testNumbersString]];
        cell.lableNums.text = [NSString stringWithFormat:@"开奖号 %@", [dataItem numbersString]];
        
        [luckItem getRecmdNums:btRecmdNums atIndex:nIndex matchCount:&nMatchCount];
    }
        
    if(nMatchCount == -2) // 没有推荐码
    {
        [cell.imageBallView setShowText:@"（暂无关注码）"];
    }
    else
    {
        [cell.imageBallView removeAllBalls];
        for (int i=0; i<btNumberCount; i++)
        {
            [cell.imageBallView addBall:(btRecmdNums[i] & 0x80 ? kBallTypeMatch : kBallTypeNormal) andValue:btRecmdNums[i] & 0x7f]; 
        }
    }
    [cell setMatchCount:nMatchCount];

    return (UITableViewCell *)cell;
}

#pragma mark - Table view delegate

#pragma mark - 
- (void)modifyLuckItem:(id)sender
{
    UIViewController *subVC = nil;
    
    switch (luckItem.btType)
    {
        case kLuckItemTypeDate:
        {
            QCLuckItemDateSetViewController *dateSetVC = [[QCLuckItemDateSetViewController alloc] initWithNibName:@"QCLuckItemDateSetViewController" bundle:nil];
            dateSetVC.luckItem = luckItem;
            subVC = dateSetVC;
        }
        break;
        case kLuckItemTypeNumber:
        {
            QCLuckItemNumSetViewController *numSetVC = [[QCLuckItemNumSetViewController alloc] initWithNibName:@"QCLuckItemNumSetViewController" bundle:nil];
            numSetVC.luckItem = luckItem;
            subVC = numSetVC;
         }
        break;
            
        default:
            assert(NO);
            return;
            break;
    } 
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        if (popoverControllerForIPad != nil)
        {
            return ;
        }
        popoverControllerForIPad = [[UIPopoverController alloc] initWithContentViewController:subVC];
        [popoverControllerForIPad setPopoverContentSize:subVC.view.frame.size];
        [popoverControllerForIPad setDelegate:self];
        [popoverControllerForIPad presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else
    {
        [self.navigationController pushViewController:subVC animated:YES];
    }
}

#pragma mark - UISplitViewControllerDelegate Method

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    [barButtonItem setTitle:@"福彩3D幸运码"];
    UIBarButtonItem *bbiDownload = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(downloadData)];
    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:barButtonItem, bbiDownload, nil] animated:YES];
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)button
{
    [self.navigationItem setLeftBarButtonItems:nil animated:YES];
}

- (void)splitViewController:(UISplitViewController *)svc popoverController:(UIPopoverController *)pc willPresentViewController:(UIViewController *)aViewController
{
    if (popoverControllerForIPad != nil)
    {
        [popoverControllerForIPad dismissPopoverAnimated:YES];
        popoverControllerForIPad = nil;
    }
}

#pragma mark -- UIPopoverControllerDelegate相关函数
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
   [[self tableView] reloadData];
    NSIndexPath *pOldPath = [self.mainVCForIPad.tableView indexPathForSelectedRow];
    [self.mainVCForIPad.tableView reloadData];
    [self.mainVCForIPad.tableView selectRowAtIndexPath:pOldPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    popoverControllerForIPad = nil;
}

#pragma mark -
- (void)downloadData
{
    if (popoverControllerForIPad != nil)
    {
        [popoverControllerForIPad dismissPopoverAnimated:YES];
        popoverControllerForIPad = nil;
    }
    UIBarButtonItem *bbi = [[self.navigationItem leftBarButtonItems] lastObject];
    [mainVCForIPad downloadData:bbi];
}
@end
