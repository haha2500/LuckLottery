//
//  QCBuyViewController.m
//  LuckLottery
//
//  Created by Sun Wu on 13-8-6.
//
//

#import "QCBuyViewController.h"
#import "QCLoginView.h"

@interface QCBuyViewController ()

@end

@implementation QCBuyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.webView.delegate = self;
    
    if (self.webView.request == nil)
    {
        [self.bbiStop setEnabled:NO];
        [self.bbiForward setEnabled:self.webView.canGoForward];
        [self.bbiBack setEnabled:self.webView.canGoBack];
        
        // 打开购买网页
        NSString *strSoftVer = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
        NSInteger loginID = [[NSUserDefaults standardUserDefaults] integerForKey:@"LoginID"];
        NSString *strURLBuy = [[NSString stringWithFormat:@"%@buy_IOS.asp?ID=%d&SoftID=1&SoftVer=%@", kBASEURL, loginID, strSoftVer] stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        NSURL *url = [NSURL URLWithString:strURLBuy];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }
    else
    {
        [self.webView reload];
    }
    
    // 设置标题
    self.navigationItem.title = @"投注";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setWebView:nil];
    [self setBbiForward:nil];
    [self setBbiBack:nil];
    [self setBbiStop:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        return YES;
    }
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)onGoBack:(id)sender {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}

- (IBAction)onGoForward:(id)sender {
    if ([self.webView canGoForward]) {
        [self.webView goForward];
    }
}

- (IBAction)onRefresh:(id)sender {
    [self.webView reload];
}

- (IBAction)onStop:(id)sender {
    [self.webView stopLoading];
}

#pragma mark -
#pragma mark UIWebViewDelegate functions 
- (void)webViewDidStartLoad:(UIWebView *)webView{
    self.navigationItem.title = @"正在载入...";
    [self.bbiStop setEnabled:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.bbiStop setEnabled:NO];
    [self.bbiForward setEnabled:self.webView.canGoForward];
    [self.bbiBack setEnabled:self.webView.canGoBack];
    self.navigationItem.title = @"投注";
//    self.navigationItem.title = self.webView.request.URL.absoluteString;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.bbiStop setEnabled:NO];
    [self.bbiForward setEnabled:self.webView.canGoForward];
    [self.bbiBack setEnabled:self.webView.canGoBack];
    self.navigationItem.title = @"载入失败";
}
@end
