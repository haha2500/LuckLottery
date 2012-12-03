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
#import "QCHelpViewController.h"
#import "QCDataStore.h"

@interface QCMainViewController ()

@end

@implementation QCMainViewController
@synthesize luckItemArray, historyVCForIPad;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) 
        {
            popoverControllerForIPad = nil;
        }
        else
        {
            // 创建广告视图，此处使用的是测试ID，请登陆多盟官网（www.domob.cn）获取新的ID
            _dmAdView = [[DMAdView alloc] initWithPublisherId:@"56OJz/2YuMyvaSJlPj" size:DOMOB_AD_SIZE_320x50];
            // 设置广告视图的位置
            _dmAdView.frame = CGRectMake(0, 0, DOMOB_AD_SIZE_320x50.width, DOMOB_AD_SIZE_320x50.height);
            _btLoadADFlag = kLoadADNeedFirstLoad;
        }
        
        // 获取设置
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"LuckItems"];
        
        if (data != nil) // 直接使用设置中的值
        {
            NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
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
            [self.luckItemArray addObject:luckItemDate];
            [self.luckItemArray addObject:luckItemNumber];
            [self.luckItemArray addObject:luckItemCST];
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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"说明" style:UIBarButtonItemStylePlain target:self action:@selector(helpInfo)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(downloadData:)];
    
    self.navigationItem.title = @"福彩3D幸运码";   // LOTTERY
    
    _btLoadADFlag = kLoadADNeedFirstLoad;
   
    [self firstLoadAD];     // 首次加载广告
    
    // 启动数据下载,APP审核不过
 //   [self downloadData:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [_dmAdView removeFromSuperview]; // 将广告试图从父视图中移除
}

- (void)viewWillAppear:(BOOL)animated
{
    BOOL bHasModified = NO;
    for (QCLuckItem *luckItem in luckItemArray)
    {
        if (luckItem.bModified) // 设置有改动
        {
            bHasModified = YES;
            luckItem.bModified = NO;
        }
    }
    
    if (bHasModified)   // 设置有改动
    {
        // 保存列表数据
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:luckItemArray];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"LuckItems"];
        
        // 刷新列表
        [self.tableView reloadData];
    }
    
    [self firstLoadAD];     // 首次加载广告
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

#pragma mark - DMAdViewDelegate Method
// 成功加载广告后，回调该方法
- (void)dmAdViewSuccessToLoadAd:(DMAdView *)adView
{
    NSLog(@"[MainViewController] success to load ad.");
    _btLoadADFlag = kLoadADLoadSuccess;
    [self.view addSubview:_dmAdView];       // 将广告视图添加到父视图中
    [self.tableView reloadData];
}

// 加载广告失败后，回调该方法
- (void)dmAdViewFailToLoadAd:(DMAdView *)adView withError:(NSError *)error
{
    NSLog(@"[MainViewController] fail to load ad. %@", error);
    if (_btLoadADFlag == kLoadADNeedFirstLoad)
    {
        return; 
    }
    _btLoadADFlag = kLoadADLoadFailure;
    [_dmAdView removeFromSuperview]; // 将广告试图从父视图中移除
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate and UITableViewDataSource Method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    int nCount = [[[QCDataStore defaultStore] dataItemArray] count];
    if (nCount == 0)
    {
        return @"请点击右上角的“刷新”按钮获取最新数据";
    }
    else
    {
        QCDataItem *dateItem = [[QCDataStore defaultStore] dataItemForecast];
        NSMutableString *strTitle = [NSMutableString stringWithFormat:@"开奖日期 %@  第%@期 \n", [dateItem dateString], [dateItem issueString]];
        NSString *strTestNums = [dateItem testNumbersString];
        if (strTestNums != nil)
        {
            [strTitle appendFormat:@"试机号 %@  ", strTestNums];
        }

        return strTitle;
    }
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
    }
    
    int nIndex = [indexPath row];
    
    QCLuckItem *luckItem = [self.luckItemArray objectAtIndex:nIndex];
    [cell setLuckItem:luckItem];
    return (UITableViewCell *)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   // return 60 + (_bADLoadOK ? 50 : 0);
    return 60 + (_btLoadADFlag == kLoadADLoadSuccess ? _dmAdView.bounds.size.height : 0);
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
    if ([[[QCDataStore defaultStore] dataItemArray] count] > 0)
    {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            self.historyVCForIPad.luckItem = [self.luckItemArray objectAtIndex:[indexPath row]];
            [self.historyVCForIPad resetLuckItemForIPad];
        }
        else
        {
            QCHistoryViewController *detailViewController = [[QCHistoryViewController alloc] initWithNibName:@"QCHistoryViewController" bundle:nil];
            detailViewController.luckItem = [self.luckItemArray objectAtIndex:[indexPath row]];
            // Pass the selected object to the new view controller.
            [self.navigationController pushViewController:detailViewController animated:YES];
        }
    }
    else
    {
        [self downloadData:nil];    // 下载数据
    }
}

#pragma mark -
- (void)helpInfo
{
    QCHelpViewController *helpVC = [[QCHelpViewController alloc] initWithNibName:@"QCHelpViewController" bundle:nil];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        if (popoverControllerForIPad != nil)
        {
            return;
        }
        popoverControllerForIPad = [[UIPopoverController alloc] initWithContentViewController:helpVC];
        [popoverControllerForIPad setPopoverContentSize:helpVC.view.frame.size];
        popoverControllerForIPad.delegate = self;
        [popoverControllerForIPad presentPopoverFromBarButtonItem:self.navigationItem.leftBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else
    {
        [[self navigationController] pushViewController:helpVC animated:YES];
    }
}

- (void)downloadData:(id)sender
{
    if (popoverControllerForIPad != nil)
    {
        [popoverControllerForIPad dismissPopoverAnimated:YES];
        popoverControllerForIPad = nil;
    }
    
    // 显示等待窗口
    waitingDialog = [[UIAlertView alloc] initWithTitle:nil message:@"正在下载相关数据，请等待 ..." delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [waitingDialog show];
	UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.center = CGPointMake(waitingDialog.bounds.size.width / 2.0f, waitingDialog.bounds.size.height - 46.0f);   
    [activityIndicator startAnimating];
	
	[waitingDialog addSubview:activityIndicator];
    
        
    NSString *strURL = [NSString stringWithFormat:@"http://software.pinble.com/cstdata2010/debug/cstdata_test.asp?ver=1&lotteryid=11000130&lastissue=%d&softwareID=1", [[QCDataStore defaultStore] lastIssue]];
    NSURL *url = [NSURL URLWithString:strURL];
    bPromptNoNewData = (sender == nil) ? NO : YES;
    NSURLRequest *requset = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    downloadData = [[NSMutableData alloc] init];
    
    connection = [[NSURLConnection alloc] initWithRequest:requset delegate:self startImmediately:YES];
}

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
{
    [downloadData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
    // 关闭等待窗口
    [waitingDialog dismissWithClickedButtonIndex:0 animated:NO];
    waitingDialog = nil;

    int nBufLen = [downloadData length];
    char *lpBuf = (char *)[downloadData bytes];
    
    // 载入新数据
    int nRtn = [[QCDataStore defaultStore] updateNums:lpBuf bufSize:nBufLen];
    if(nRtn > 0)
    {
        // 重新显示列表
        [[self tableView] reloadData];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            [self.historyVCForIPad.tableView reloadData];
        }
    }
    else
    {
        if (nRtn != 0 || bPromptNoNewData)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:((nRtn == 0) ? @"当前已是最新数据。" : @"下载数据失败，请稍后再试。") delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            [alert show];
        }
    }
    [connection cancel];
    connection = nil;
    downloadData = nil;
    
    [self firstLoadAD];     // 首次加载广告
}

- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error
{
    // 关闭等待窗口
    [waitingDialog dismissWithClickedButtonIndex:0 animated:NO];
    waitingDialog = nil;
    
    connection = nil;
    downloadData = nil;
    NSString *errorString = [NSString stringWithFormat:@"下载数据失败：%@", [error localizedDescription]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:errorString delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
    [alert show];
    
    [self firstLoadAD];     // 首次加载广告
}

#pragma mark -- UIPopoverControllerDelegate相关函数
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    popoverControllerForIPad = nil;
}

#pragma mark - 
- (void)firstLoadAD
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        return ;    // IPAD则不加载广告
    }
    
    if (_btLoadADFlag == kLoadADNeedFirstLoad)  // 第一次加载广告
    {
        _dmAdView.delegate = self;              // 设置 Delegate
        _dmAdView.rootViewController = self;    // 设置 RootViewController
        [_dmAdView loadAd];                     // 开始加载广告
    }
}
@end
